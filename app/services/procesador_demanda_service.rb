# frozen_string_literal: true

class ProcesadorDemandaService
  include Rails.application.routes.url_helpers

  MAX_OPENAI_RETRIES = 5
  OPENAI_BACKOFF_BASE = 2.0

  class OpenAIRateLimitError < StandardError; end
  class OpenAIServiceUnavailableError < StandardError; end
  class OpenAITimeoutError < StandardError; end

  def initialize(act_archivo)
    @act_archivo = act_archivo
    Rails.logger.info("[ProcesadorDemandaService] 🆕 Initializing service for ActArchivo #{@act_archivo.id}")
    raise ActiveRecord::RecordNotFound unless @act_archivo.persisted?

    @identificadores = { demandantes: {}, demandados: {}, testigos: {} }
    @contadores = { demandantes: 0, demandados: 0, testigos: 0 }
    @rate_limiter = OpenAIRateLimiter.instance
  end

  def procesar!
    Rails.logger.info("[ProcesadorDemandaService] 🚀 Starting processing for ActArchivo #{@act_archivo.id}")
    
    return false unless puede_procesar?
    Rails.logger.info("[ProcesadorDemandaService] ✅ Passed puede_procesar? check")

    texto_pdf = extraer_texto_pdf
    Rails.logger.info("[ProcesadorDemandaService] 📄 Extracted PDF text, length: #{texto_pdf&.length || 0}")
    
    return false if texto_pdf.blank?
    Rails.logger.info("[ProcesadorDemandaService] ✅ PDF text is present")

    # Process sequentially with detailed logging
    Rails.logger.info("[ProcesadorDemandaService] 👥 Generating participant list")
    generar_lista_participantes(texto_pdf)
    Rails.logger.info("[ProcesadorDemandaService] ✅ Generated participant list")

    Rails.logger.info("[ProcesadorDemandaService] 📝 Generating anonymized summary")
    generar_resumen_anonimizado(texto_pdf)
    Rails.logger.info("[ProcesadorDemandaService] ✅ Generated anonymized summary")

    Rails.logger.info("[ProcesadorDemandaService] 📋 Generating facts list")
    generar_lista_hechos(texto_pdf)
    Rails.logger.info("[ProcesadorDemandaService] ✅ Generated facts list")

    adjuntar_archivos_generados
    Rails.logger.info("[ProcesadorDemandaService] 💾 Attached generated files")
    
    Rails.logger.info("[ProcesadorDemandaService] 🎉 Processing completed successfully")
    true
  rescue StandardError => e
    Rails.logger.error("[ProcesadorDemandaService] 💥 Error in procesar!: #{e.message}")
    Rails.logger.error("[ProcesadorDemandaService] Backtrace: #{e.backtrace.join("\n")}")
    false
  end

  private

  def puede_procesar?
    Rails.logger.info("[ProcesadorDemandaService] 🔍 Checking processing conditions")
    
    result = @act_archivo.act_archivo == "demanda" &&
             @act_archivo.pdf.attached? &&
             @act_archivo.persisted?
    
    Rails.logger.info("[ProcesadorDemandaService] 📊 puede_procesar? result: #{result}")
    Rails.logger.info("[ProcesadorDemandaService] 📋 act_archivo: #{@act_archivo.act_archivo}")
    Rails.logger.info("[ProcesadorDemandaService] 📎 pdf attached: #{@act_archivo.pdf.attached?}")
    Rails.logger.info("[ProcesadorDemandaService] 💾 persisted: #{@act_archivo.persisted?}")
    
    result
  end

  def extraer_texto_pdf
    Rails.logger.info("[ProcesadorDemandaService] 📄 Starting PDF text extraction")
    
    begin
      pdf_path = ActiveStorage::Blob.service.path_for(@act_archivo.pdf.key)
      Rails.logger.info("[ProcesadorDemandaService] 📍 PDF path: #{pdf_path}")
      
      reader = PDF::Reader.new(pdf_path)
      Rails.logger.info("[ProcesadorDemandaService] 📖 PDF has #{reader.page_count} pages")
      
      text = reader.pages.map(&:text).join("\n")
      Rails.logger.info("[ProcesadorDemandaService] ✅ Successfully extracted PDF text, #{text.length} characters")
      
      text
    rescue PDF::Reader::MalformedPDFError => e
      Rails.logger.error("[ProcesadorDemandaService] ❌ PDF is malformed: #{e.message}")
      nil
    rescue StandardError => e
      Rails.logger.error("[ProcesadorDemandaService] ❌ Error extracting texto del PDF: #{e.message}")
      Rails.logger.error("[ProcesadorDemandaService] Backtrace: #{e.backtrace.join("\n")}")
      nil
    end
  end

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

  def calculate_backoff(retry_count)
    backoff = (OPENAI_BACKOFF_BASE ** retry_count) + rand(0.1..1.0)
    backoff = [backoff, 60].min # Cap at 60 seconds
    Rails.logger.info("[ProcesadorDemandaService] ⏰ Calculated backoff: #{backoff}s for retry #{retry_count}")
    backoff
  end

  # --------------------------------------------------
  # Generación de documentos
  # --------------------------------------------------
  def generar_lista_participantes(texto)
    Rails.logger.info("[ProcesadorDemandaService] 👥 Building participants prompt")
    prompt = build_participantes_prompt(texto)
    
    Rails.logger.info("[ProcesadorDemandaService] 📤 Sending participants request to OpenAI")
    respuesta = chat_with_retry(prompt)
    
    content = respuesta.dig("choices", 0, "message", "content")
    Rails.logger.info("[ProcesadorDemandaService] 📥 Received OpenAI response for participants")
    
    participantes = safe_json_parse(content)
    Rails.logger.info("[ProcesadorDemandaService] 📊 Parsed participants: #{participantes}")
    
    asignar_identificadores(participantes)
    @documento_participantes = crear_documento_participantes(participantes)
    
    Rails.logger.info("[ProcesadorDemandaService] ✅ Participants list generated")
  end

  def generar_resumen_anonimizado(texto)
    Rails.logger.info("[ProcesadorDemandaService] 📝 Building summary prompt")
    prompt = build_resumen_prompt(texto)
    
    Rails.logger.info("[ProcesadorDemandaService] 📤 Sending summary request to OpenAI")
    respuesta = chat_with_retry(prompt)
    
    @documento_resumen = respuesta.dig("choices", 0, "message", "content")
    Rails.logger.info("[ProcesadorDemandaService] ✅ Anonymized summary generated, length: #{@documento_resumen.length}")
  end

  def generar_lista_hechos(texto)
    Rails.logger.info("[ProcesadorDemandaService] 📋 Building facts prompt")
    prompt = build_hechos_prompt(texto)
    
    Rails.logger.info("[ProcesadorDemandaService] 📤 Sending facts request to OpenAI")
    respuesta = chat_with_retry(prompt)
    
    @documento_hechos = respuesta.dig("choices", 0, "message", "content")
    Rails.logger.info("[ProcesadorDemandaService] ✅ Facts list generated, length: #{@documento_hechos.length}")
  end

  def safe_json_parse(content)
    Rails.logger.info("[ProcesadorDemandaService] 🔍 Parsing JSON response")
    JSON.parse(content)
  rescue JSON::ParserError => e
    Rails.logger.error("[ProcesadorDemandaService] ❌ Failed to parse JSON from OpenAI: #{e.message}")
    Rails.logger.error("[ProcesadorDemandaService] 📄 Content was: #{content}")
    # Fallback to empty structure
    { "demandantes" => [], "demandados" => [], "testigos" => [] }
  end

  # --------------------------------------------------
  # Armado de prompts (mantener igual)
  # --------------------------------------------------
  def build_participantes_prompt(texto)
    Rails.logger.info("[ProcesadorDemandaService] 📝 Building participants prompt")
    truncated_text = texto[0..6000]
    
    <<~PROMPT
      Analiza el siguiente texto de una demanda legal y extrae:
      1. Todos los demandantes con sus cédulas/RUN/RUT
      2. Todos los demandados con sus cédulas/RUN/RUT
      3. Todos los testigos con sus cédulas/RUN/RUT

      Para cada persona necesito:
      - Nombre completo
      - Cédula de identidad/RUN/RUT
      - Rol (demandante/demandado/testigo)

      Texto de la demanda:
      #{truncated_text}

      Devuelve la información en formato JSON con esta estructura:
      {
        "demandantes": [{"nombre": "...", "identificacion": "..."}],
        "demandados":  [{"nombre": "...", "identificacion": "..."}],
        "testigos":    [{"nombre": "...", "identificacion": "..."}]
      }

      Si no hay datos para alguna categoría, devuelve array vacío.
    PROMPT
  end

  def build_resumen_prompt(texto)
    Rails.logger.info("[ProcesadorDemandaService] 📝 Building summary prompt")
    truncated_text = texto[0..6000]
    
    <<~PROMPT
      Basándote en el siguiente texto de demanda, crea un resumen que incluya:

      1. Identificación de demandantes (usa los identificadores proporcionados)
      2. Montos demandados detallados por concepto

      Usa estos identificadores para anonimizar:
      #{@identificadores[:demandantes].to_json}

      Texto de la demanda:
      #{truncated_text}

      Devuelve el resumen en formato de texto estructurado.
    PROMPT
  end

  def build_hechos_prompt(texto)
    Rails.logger.info("[ProcesadorDemandaService] 📝 Building facts prompt")
    truncated_text = texto[0..6000]
    
    <<~PROMPT
      Extrae del siguiente texto de demanda todos los hechos fundamentales.

      Para cada hecho:
      1. Identifica la fecha (si existe)
      2. Extrae la descripción completa del hecho
      3. Anonimiza los nombres usando estos identificadores:
         #{@identificadores.to_json}

      Presenta los hechos con este formato:
      ===
      FECHA: [fecha del hecho]
      HECHO: [descripción anonimizada del hecho]
      ===

      Texto de la demanda:
      #{truncated_text}
    PROMPT
  end

  # --------------------------------------------------
  # Lógica de identificadores (mantener igual)
  # --------------------------------------------------
  def asignar_identificadores(participantes)
    Rails.logger.info("[ProcesadorDemandaService] 🔤 Assigning identifiers")
    
    participantes["demandantes"]&.each do |d|
      @contadores[:demandantes] += 1
      @identificadores[:demandantes][d["nombre"]] = "DNNCNT-#{@contadores[:demandantes]}"
    end
    
    participantes["demandados"]&.each do |d|
      @contadores[:demandados] += 1
      @identificadores[:demandados][d["nombre"]] = "DNNCD-#{@contadores[:demandados]}"
    end
    
    participantes["testigos"]&.each do |t|
      @contadores[:testigos] += 1
      @identificadores[:testigos][t["nombre"]] = "TSTG-#{@contadores[:testigos]}"
    end
    
    Rails.logger.info("[ProcesadorDemandaService] ✅ Identifiers assigned: #{@identificadores}")
  end

  def crear_documento_participantes(participantes)
    Rails.logger.info("[ProcesadorDemandaService] 📄 Creating participants document")
    
    lines = []
    lines << "LISTA DE PARTICIPANTES - DEMANDA"
    lines << "====================================="
    lines << ""
    lines << "DEMANDANTES:"
    participantes["demandantes"]&.each do |d|
      lines << "- #{@identificadores[:demandantes][d["nombre"]]}: #{d["nombre"]} - #{d["identificacion"]}"
    end
    lines << ""
    lines << "DEMANDADOS:"
    participantes["demandados"]&.each do |d|
      lines << "- #{@identificadores[:demandados][d["nombre"]]}: #{d["nombre"]} - #{d["identificacion"]}"
    end
    lines << ""
    lines << "TESTIGOS:"
    participantes["testigos"]&.each do |t|
      lines << "- #{@identificadores[:testigos][t["nombre"]]}: #{t["nombre"]} - #{t["identificacion"]}"
    end
    
    document = lines.join("\n")
    Rails.logger.info("[ProcesadorDemandaService] ✅ Participants document created, #{document.length} characters")
    document
  end

  # --------------------------------------------------
  # Adjuntar / guardar resultados (mantener igual)
  # --------------------------------------------------
  def adjuntar_archivos_generados
    Rails.logger.info("[ProcesadorDemandaService] 💾 Saving generated documents")
    
    crear_act_texto(
      tipo: "lista_participantes",
      titulo: "Lista de Participantes - Demanda #{@act_archivo.id}",
      contenido: formatear_contenido_lista_participantes
    )
    
    crear_act_texto(
      tipo: "resumen_anonimizado",
      titulo: "Resumen Anonimizado - Demanda #{@act_archivo.id}",
      contenido: formatear_contenido_resumen
    )
    
    crear_act_texto(
      tipo: "lista_hechos",
      titulo: "Lista de Hechos - Demanda #{@act_archivo.id}",
      contenido: formatear_contenido_hechos
    )
    
    Rails.logger.info("[ProcesadorDemandaService] ✅ All documents saved")
  end

  def crear_act_texto(tipo:, titulo:, contenido:)
    Rails.logger.info("[ProcesadorDemandaService] 💾 Saving ActTexto for #{tipo}")
    
    act_texto = @act_archivo.act_textos.find_or_initialize_by(tipo_documento: tipo)
    act_texto.titulo   = titulo
    act_texto.contenido = contenido
    act_texto.metadata = {
      identificadores: @identificadores,
      procesado_en: Time.current,
      version: (act_texto.version || 0) + 1
    }
    act_texto.save!
    
    Rails.logger.info("[ProcesadorDemandaService] ✅ ActTexto saved for #{tipo}, id: #{act_texto.id}")
  rescue => e
    Rails.logger.error("[ProcesadorDemandaService] ❌ Error saving ActTexto for #{tipo}: #{e.message}")
    raise e
  end

  def formatear_contenido_lista_participantes
    <<~HTML
      <h1>Lista de Participantes - Demanda</h1>
      <hr>
      <pre>#{@documento_participantes}</pre>
    HTML
  end

  def formatear_contenido_resumen
    <<~HTML
      <h1>Resumen Anonimizado</h1>
      <hr>
      #{@documento_resumen}
    HTML
  end

  def formatear_contenido_hechos
    <<~HTML
      <h1>Lista de Hechos</h1>
      <hr>
      #{@documento_hechos}
    HTML
  end

  # --------------------------------------------------
  # Cliente OpenAI (CORREGIDO)
  # --------------------------------------------------
  def cliente_openai
    @cliente_openai ||= begin
      Rails.logger.info("[ProcesadorDemandaService] 🔧 Initializing OpenAI client")
      # CORREGIDO: No usar request_timeout en esta versión
      client = OpenAI::Client.new(
        access_token: ENV['OPENAI_API_KEY']
        # REMOVIDO: request_timeout y log_errors no son parámetros válidos
      )
      Rails.logger.info("[ProcesadorDemandaService] ✅ OpenAI client initialized")
      client
    end
  end
end

# Rate Limiter Class (mantener igual)
class OpenAIRateLimiter
  include Singleton

  def initialize(requests_per_minute: 50)
    @mutex = Mutex.new
    @requests = []
    @limit = requests_per_minute
    Rails.logger.info("[OpenAIRateLimiter] 🔧 Initialized with #{requests_per_minute} requests per minute")
  end

  def wait_for_capacity
    @mutex.synchronize do
      now = Time.now
      @requests.reject! { |time| time < now - 60 }
      
      if @requests.size >= @limit
        sleep_until = @requests.first + 60
        sleep_time = [sleep_until - now, 0].max
        Rails.logger.info("[OpenAIRateLimiter] ⏳ Rate limit reached, sleeping for #{sleep_time.round(2)}s")
        sleep(sleep_time) if sleep_time > 0
        @requests.shift
      end
      
      @requests << now
      Rails.logger.info("[OpenAIRateLimiter] ✅ Capacity available, current requests in window: #{@requests.size}/#{@limit}")
    end
  end
end