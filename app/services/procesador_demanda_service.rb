# frozen_string_literal: true

class ProcesadorDemandaService
  include Rails.application.routes.url_helpers
  require Rails.root.join('app/lib/tipos_documento')   # carga TODO

  attr_reader :act_archivo   # ← ESTA LÍNEA
  
  MAX_OPENAI_RETRIES = 5
  OPENAI_BACKOFF_BASE = 2.0

  class OpenAIRateLimitError < StandardError; end
  class OpenAIServiceUnavailableError < StandardError; end
  class OpenAITimeoutError < StandardError; end

  def initialize(act_archivo)
    @act_archivo = act_archivo
    Rails.logger.info("[ProcesadorDemandaService] 🆕 Initializing service for ActArchivo #{@act_archivo.id}")
    raise ActiveRecord::RecordNotFound unless @act_archivo.persisted?

    @rate_limiter = OpenaiRateLimiter.instance
  end

  def procesar!
    Rails.logger.info("[ProcesadorDemandaService] 🚀 Starting processing for #{@act_archivo.act_archivo} – #{@act_archivo.id}")

    return false unless puede_procesar?

    texto = extraer_texto_pdf
    return false if texto.blank?

    processor_class = TiposDocumento::REGISTRY[@act_archivo.act_archivo]
    raise ArgumentError, "Unknown act_archivo kind: #{@act_archivo.act_archivo}" unless processor_class

    processor_class.new(self).procesar!
    Rails.logger.info("[ProcesadorDemandaService] 🎉 Processing completed successfully")
    true
  rescue StandardError => e
    Rails.logger.error("[ProcesadorDemandaService] 💥 Error in procesar!: #{e.message}")
    Rails.logger.error("[ProcesadorDemandaService] Backtrace: #{e.backtrace.join("\n")}")
    false
  end

  private

  def puede_procesar?
    @act_archivo.act_archivo.in?(TiposDocumento::REGISTRY.keys) &&
      @act_archivo.pdf.attached? &&
      @act_archivo.persisted?
  end

  def extraer_texto_pdf
    Rails.logger.info("[ProcesadorDemandaService] 📄 Starting PDF text extraction")
    pdf_path = ActiveStorage::Blob.service.path_for(@act_archivo.pdf.key)
    reader   = PDF::Reader.new(pdf_path)
    text     = reader.pages.map(&:text).join("\n")
    Rails.logger.info("[ProcesadorDemandaService] ✅ Extracted #{text.length} characters")
    text
  rescue PDF::Reader::MalformedPDFError => e
    Rails.logger.error("[ProcesadorDemandaService] ❌ Malformed PDF: #{e.message}")
    nil
  rescue StandardError => e
    Rails.logger.error("[ProcesadorDemandaService] ❌ Error extracting PDF: #{e.message}")
    nil
  end

  # ----------  expón los helpers a los procesadores  ----------
  def chat_with_retry(prompt, max_retries: MAX_OPENAI_RETRIES)
    Rails.logger.info("[ProcesadorDemandaService] 🤖 Starting chat_with_retry, prompt length: #{prompt.length}")
    
    retries = 0
    last_error = nil

    while retries <= max_retries
      begin
        Rails.logger.info("[ProcesadorDemandaService] 🔄 Attempt #{retries + 1}/#{max_retries + 1}")
        
        # Wait for rate limiter capacity
        if @rate_limiter
          Rails.logger.info("[ProcesadorDemandaService] ⏳ Waiting for rate limiter capacity")
          @rate_limiter.wait_for_capacity
        end
        
        Rails.logger.info("[ProcesadorDemandaService] 📡 Sending request to OpenAI")
        
        # CORREGIDO: Usar parámetros válidos para ruby-openai
        response = cliente_openai.chat(
          parameters: {
            model: "gpt-4",
            messages: [{ role: "user", content: prompt }],
            max_tokens: 4000,
            temperature: 0.3
            # REMOVIDO: request_timeout no es un parámetro válido en esta versión
          }
        )

        Rails.logger.info("[ProcesadorDemandaService] ✅ OpenAI response received successfully")
        return response

      rescue Faraday::TooManyRequestsError => e
        # CORREGIDO: Usar Faraday::TooManyRequestsError en lugar de OpenAI::Error::RateLimitError
        last_error = OpenAIRateLimitError.new("Rate limit exceeded: #{e.message}")
        retries += 1
        if retries <= max_retries
          sleep_time = calculate_backoff(retries)
          Rails.logger.warn("[ProcesadorDemandaService] ⚠️ OpenAI 429 – retry #{retries}/#{max_retries} after #{sleep_time}s")
          sleep(sleep_time)
        else
          Rails.logger.error("[ProcesadorDemandaService] ❌ OpenAI rate limit retries exhausted after #{max_retries} attempts")
          raise last_error
        end

      rescue Faraday::TimeoutError => e
        # CORREGIDO: Usar Faraday::TimeoutError
        last_error = OpenAITimeoutError.new("OpenAI timeout: #{e.message}")
        retries += 1
        if retries <= max_retries
          sleep_time = calculate_backoff(retries)
          Rails.logger.warn("[ProcesadorDemandaService] ⏰ OpenAI timeout – retry #{retries}/#{max_retries} after #{sleep_time}s")
          sleep(sleep_time)
        else
          raise last_error
        end

      rescue Faraday::ConnectionFailed, Faraday::ServerError => e
        # CORREGIDO: Manejar otros errores de Faraday
        last_error = OpenAIServiceUnavailableError.new("OpenAI service unavailable: #{e.message}")
        retries += 1
        if retries <= max_retries
          sleep_time = calculate_backoff(retries)
          Rails.logger.warn("[ProcesadorDemandaService] 🔧 OpenAI service unavailable – retry #{retries}/#{max_retries} after #{sleep_time}s")
          sleep(sleep_time)
        else
          raise last_error
        end

      rescue => e
        Rails.logger.error("[ProcesadorDemandaService] ❌ Unexpected error in chat_with_retry: #{e.message}")
        Rails.logger.error("[ProcesadorDemandaService] Error class: #{e.class}")
        raise e
      end
    end

    raise last_error
  end

  def crear_act_texto(tipo:, titulo:, contenido:)
    act_texto = @act_archivo.act_textos.find_or_initialize_by(tipo_documento: tipo)
    act_texto.titulo    = titulo
    act_texto.contenido = contenido
    act_texto.metadata  = {
      procesado_en: Time.current,
      version:      (act_texto.version || 0) + 1
    }
    act_texto.save!
  end

  def cliente_openai
    @cliente_openai ||= OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
  end
end