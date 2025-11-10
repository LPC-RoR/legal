# frozen_string_literal: true

class ProcesadorDemandaService
  include Rails.application.routes.url_helpers
  require Rails.root.join('app/lib/tipos_documento')

  attr_reader :act_archivo

  # ===================================================================
  # CONFIGURACIÓN CENTRALIZADA
  # ===================================================================
  MAX_OPENAI_RETRIES = 7          # Total intentos: 8 (1 inicial + 7 reintentos)
  OPENAI_BACKOFF_BASE = 4.0       # Exponencial: 4, 16, 64, 256, 1024, 4096, 16384s
  OPENAI_RATE_LIMIT = 30          # Requests por minuto (conservador)
  CIRCUIT_BREAKER_THRESHOLD = 2   # Fallos para abrir circuito
  CIRCUIT_BREAKER_TIMEOUT = 600   # 10 minutos en estado abierto

  # Clases de error personalizadas
  class OpenAIRateLimitError < StandardError; end
  class OpenAIServiceUnavailableError < StandardError; end
  class OpenAITimeoutError < StandardError; end

  # ===================================================================
  # INICIALIZACIÓN
  # ===================================================================
  def initialize(act_archivo)
    @act_archivo = act_archivo
    Rails.logger.info("[ProcesadorDemandaService] 🆕 Inicializando para ActArchivo ##{@act_archivo.id}")
    
    raise ActiveRecord::RecordNotFound unless @act_archivo.persisted?

    @rate_limiter = OpenaiRateLimiter.instance
    @circuit_breaker = CircuitBreaker.new(
      threshold: CIRCUIT_BREAKER_THRESHOLD, 
      timeout: CIRCUIT_BREAKER_TIMEOUT
    )
  end

  # ===================================================================
  # MÉTODO PRINCIPAL
  # ===================================================================
  def procesar!
    Rails.logger.info("[ProcesadorDemandaService] 🚀 Procesando #{@act_archivo.act_archivo} ##{@act_archivo.id}")

    return false unless puede_procesar?

    # Extrae texto solo una vez
    texto = extraer_texto_pdf
    return false if texto.blank?

    processor_class = TiposDocumento::REGISTRY[@act_archivo.act_archivo]
    raise ArgumentError, "Tipo desconocido: #{@act_archivo.act_archivo}" unless processor_class

    # Pasa texto extraído para evitar re-extracción
    processor_class.new(self, texto).procesar!
    
    Rails.logger.info("[ProcesadorDemandaService] 🎉 Procesamiento completado exitosamente")
    true
    
  rescue StandardError => e
    Rails.logger.error("[ProcesadorDemandaService] 💥 Error en procesar!: #{e.class} - #{e.message}")
    Rails.logger.error("[ProcesadorDemandaService] #{e.backtrace.first(5).join("\n")}")
    false
  end

  # ===================================================================
  # MÉTODOS PRIVADOS - ORDEN LÓGICO
  # ===================================================================
  private

  # ------------------------------------------------------------
  # Validación
  # ------------------------------------------------------------
  def puede_procesar?
    @act_archivo.act_archivo.in?(TiposDocumento::REGISTRY.keys) &&
      @act_archivo.pdf.attached? &&
      @act_archivo.persisted?
  end

  # ------------------------------------------------------------
  # Extracción de texto
  # ------------------------------------------------------------
  def extraer_texto_pdf
    Rails.logger.info("[ProcesadorDemandaService] 📄 Extrayendo texto del PDF")
    
    pdf_path = ActiveStorage::Blob.service.path_for(@act_archivo.pdf.key)
    reader = PDF::Reader.new(pdf_path)
    
    # Asegúrate de extraer TODAS las páginas sin truncamiento
    full_text = reader.pages.map.with_index do |page, index|
      Rails.logger.debug("[ProcesadorDemandaService] 📄 Página #{index + 1}/#{reader.pages.count}")
      page.text
    end.join("\n")
    
    Rails.logger.info("[ProcesadorDemandaService] ✅ Extraídos #{full_text.length} caracteres de #{reader.pages.count} páginas")
    full_text
  rescue => e
    Rails.logger.error("[ProcesadorDemandaService] ❌ Error extrayendo PDF: #{e.message}")
    nil
  end

  # ------------------------------------------------------------
  # Creación de registros
  # ------------------------------------------------------------
  def crear_act_texto(tipo:, titulo:, contenido:)
    act_texto = @act_archivo.act_textos.find_or_initialize_by(tipo_documento: tipo)
    act_texto.titulo = titulo
    act_texto.contenido = contenido
    act_texto.metadata = {
      procesado_en: Time.current,
      version: (act_texto.metadata&.dig('version') || 0) + 1
    }
    act_texto.save!
  end

  # ------------------------------------------------------------
  # Cliente OpenAI
  # ------------------------------------------------------------
  def cliente_openai
    @cliente_openai ||= OpenAI::Client.new(
      access_token: ENV['OPENAI_API_KEY'],
      request_timeout: 120  # 2 minutos de timeout
    )
  end

  # ------------------------------------------------------------
  # Manejo de reintentos con circuit breaker
  # ------------------------------------------------------------
  def chat_with_retry(prompt, max_retries: MAX_OPENAI_RETRIES)

    # Verifica y trunca si es necesario
    token_count = TokenCounter.count(prompt)
    if token_count > 9000
      Rails.logger.warn("[TokenCounter] ⚠️ Prompt excede 9000 tokens: #{token_count}. Truncando...")
      prompt = TokenCounter.safe_truncation(prompt, max_tokens: 9000)
    end

    @circuit_breaker.call do
      retries = 0
      last_error = nil

      while retries <= max_retries
        begin
          Rails.logger.info("[ProcesadorDemandaService] 🔄 Intento #{retries + 1}/#{max_retries + 1}")
          
          @rate_limiter.wait_for_capacity
          
          Rails.logger.info("[ProcesadorDemandaService] 📡 Enviando solicitud a OpenAI")
          
          # Línea 52 (en chat_with_retry): Cambia el modelo
          response = cliente_openai.chat(
            parameters: {
              model: "gpt-4-turbo-preview",  # 128k tokens vs 8k de gpt-4
              messages: [{ role: "user", content: prompt }],
              max_tokens: 4000,
              temperature: 0.3
            }
          )

          Rails.logger.info("[ProcesadorDemandaService] ✅ Respuesta recibida")
          return response
          
        rescue Faraday::TooManyRequestsError => e
          last_error = OpenAIRateLimitError.new("Rate limit: #{e.message}")
          handle_retry(last_error, retries, max_retries)
          
        rescue Faraday::TimeoutError => e
          last_error = OpenAITimeoutError.new("Timeout: #{e.message}")
          handle_retry(last_error, retries, max_retries)
          
        rescue Faraday::ConnectionFailed, Faraday::ServerError => e
          last_error = OpenAIServiceUnavailableError.new("Service error: #{e.message}")
          handle_retry(last_error, retries, max_retries)
          
        rescue => e
          Rails.logger.error("[ProcesadorDemandaService] ❌ Error inesperado: #{e.class} - #{e.message}")
          raise e
        end
        
        retries += 1
      end

      Rails.logger.error("[ProcesadorDemandaService] ❌ Reintentos agotados")
      raise last_error
    end
  end

  # ------------------------------------------------------------
  # Métodos auxiliares para reintentos
  # ------------------------------------------------------------
  def handle_retry(error, retries, max_retries)
    if retries < max_retries
      sleep_time = calculate_backoff(retries + 1)
      Rails.logger.warn("[ProcesadorDemandaService] ⚠️ #{error.class} - reintento #{retries + 1}/#{max_retries + 1} en #{sleep_time}s")
      sleep(sleep_time)
    else
      Rails.logger.error("[ProcesadorDemandaService] ❌ Reintentos agotados después de #{max_retries + 1} intentos")
      raise error
    end
  end

  def calculate_backoff(attempt)
    # Exponencial con jitter: 4^attempt ± 25%
    base = OPENAI_BACKOFF_BASE**attempt
    jitter = base * (0.25 * (rand - 0.5))  # ±12.5% aleatorio
    [base + jitter, 3600].min.round(1)  # Máximo 1 hora
  end
end