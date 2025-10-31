# app/jobs/procesador_demanda_job.rb
class ProcesadorDemandaJob < ApplicationJob
  queue_as :default
  
  # Reintentar hasta 5 veces con backoff exponencial
  retry_on ActiveRecord::RecordNotFound, wait: :exponentially_longer, attempts: 5
  retry_on StandardError, wait: :exponentially_longer, attempts: 3

  def perform(act_archivo)
    # Verificar que el registro existe y tiene PDF adjunto
    return unless act_archivo.persisted? && act_archivo.pdf.attached?
    
    ProcesadorDemandaService.new(act_archivo).procesar!
    
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "ActArchivo no encontrado: #{e.message}"
    # No re-raise para que no reintente indefinidamente si el registro fue eliminado
    return
  rescue StandardError => e
    Rails.logger.error "Error procesando demanda #{act_archivo&.id}: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    
    # Notificar al usuario del error (opcional)
    # UserMailer.procesamiento_error(act_archivo, e.message).deliver_later
    
    raise e # Re-lanzar para que el job reintente
  end
end