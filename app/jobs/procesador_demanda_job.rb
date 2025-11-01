class ProcesadorDemandaJob < ApplicationJob
  queue_as :low_priority

  # Actualizado con los nuevos errores
  retry_on ProcesadorDemandaService::OpenAIRateLimitError,
           wait: ->(executions) { (executions ** 2) + rand(1..3) },
           attempts: 5

  retry_on ProcesadorDemandaService::OpenAIServiceUnavailableError,
           wait: 5.minutes,
           attempts: 3

  retry_on ProcesadorDemandaService::OpenAITimeoutError,
           wait: ->(executions) { (executions ** 2) + rand(1..3) },
           attempts: 3

  retry_on ActiveRecord::RecordNotFound,
           wait: :exponentially_longer,
           attempts: 3

  retry_on StandardError,
           wait: ->(executions) { (executions ** 2) + rand(1..3) },
           attempts: 3

  discard_on JSON::ParserError do |job, error|
    Rails.logger.error("[#{job.job_id}] JSON parsing error, discarding: #{error.message}")
  end

  before_perform do |job|
    @start_time = Time.current
    Rails.logger.info("[#{job.job_id}] ======= INICIANDO PROCESADOR DEMANDA JOB =======")
  end

  after_perform do |job|
    duration = Time.current - @start_time
    Rails.logger.info("[#{job.job_id}] ======= PROCESADOR DEMANDA JOB COMPLETADO en #{duration.round(2)}s =======")
  end

  def perform(act_archivo_id)
    @act_archivo_id = act_archivo_id
    
    Rails.logger.info("[#{job_id}] 🚀 Starting processing for ActArchivo #{act_archivo_id}")
    
    act_archivo = load_act_archivo
    return unless act_archivo
    
    unless should_process?(act_archivo)
      Rails.logger.info("[#{job_id}] ⏭️ Skipping ActArchivo #{act_archivo_id} - already processed or invalid")
      return
    end

    process_act_archivo(act_archivo)
    
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("[#{job_id}] ❌ ActArchivo #{act_archivo_id} not found: #{e.message}")
    raise e
    
  rescue ProcesadorDemandaService::OpenAIRateLimitError => e
    Rails.logger.warn("[#{job_id}] ⚠️ OpenAI rate limit: #{e.message}")
    raise e
    
  rescue ProcesadorDemandaService::OpenAIServiceUnavailableError => e
    Rails.logger.warn("[#{job_id}] ⚠️ OpenAI service unavailable: #{e.message}")
    raise e
    
  rescue StandardError => e
    Rails.logger.error("[#{job_id}] 💥 Unexpected error: #{e.message}")
    Rails.logger.error("[#{job_id}] Backtrace: #{e.backtrace.take(10).join("\n")}")
    raise e
  end

  private

  def load_act_archivo
    Rails.logger.info("[#{job_id}] 📥 Loading ActArchivo #{@act_archivo_id}")
    act_archivo = ActArchivo.find(@act_archivo_id)
    Rails.logger.info("[#{job_id}] ✅ Successfully loaded ActArchivo #{@act_archivo_id}")
    act_archivo
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("[#{job_id}] ❌ Failed to load ActArchivo #{@act_archivo_id}: #{e.message}")
    nil
  end

  def should_process?(act_archivo)
    Rails.logger.info("[#{job_id}] 🔍 Checking if should process ActArchivo #{act_archivo.id}")
    
    return false unless act_archivo.persisted?
    Rails.logger.info("[#{job_id}] ✅ ActArchivo is persisted")
    
    return false unless act_archivo.pdf.attached?
    Rails.logger.info("[#{job_id}] ✅ PDF is attached")
    
    # Check if already processing
    if act_archivo.processing_status == 'processing'
      Rails.logger.warn("[#{job_id}] ⏸️ ActArchivo #{act_archivo.id} is already being processed")
      return false
    end
    
    # Check if recently processed (optional)
    if act_archivo.processing_status == 'completed' && 
       act_archivo.processed_at && 
       act_archivo.processed_at > 1.hour.ago
      Rails.logger.info("[#{job_id}] 🔄 ActArchivo #{act_archivo.id} was processed recently")
      return false
    end
    
    Rails.logger.info("[#{job_id}] ✅ All checks passed - will process ActArchivo #{act_archivo.id}")
    true
  end

  def process_act_archivo(act_archivo)
    # Mark as processing
    Rails.logger.info("[#{job_id}] 🏷️ Marking as processing")
    act_archivo.mark_processing!
    
    start_time = Time.current
    
    begin
      Rails.logger.info("[#{job_id}] 🔧 Initializing ProcesadorDemandaService")
      service = ProcesadorDemandaService.new(act_archivo)
      
      Rails.logger.info("[#{job_id}] ⚡ Calling procesar! method")
      result = service.procesar!
      
      duration = Time.current - start_time
      
      if result
        act_archivo.mark_completed!
        Rails.logger.info("[#{job_id}] ✅ Successfully processed ActArchivo #{act_archivo.id} in #{duration.round(2)}s")
      else
        act_archivo.mark_failed!
        Rails.logger.warn("[#{job_id}] ❌ Processing returned false for ActArchivo #{act_archivo.id} after #{duration.round(2)}s")
      end
      
      result

    rescue => e
      # Mark as failed on any error
      act_archivo.mark_failed!
      duration = Time.current - start_time
      Rails.logger.error("[#{job_id}] 💥 Error processing ActArchivo #{act_archivo.id} after #{duration.round(2)}s: #{e.message}")
      Rails.logger.error("[#{job_id}] Backtrace: #{e.backtrace.join("\n")}")
      raise e
    end
  end
end