# app/services/procesador_demanda_service.rb
# frozen_string_literal: true
class ProcesadorDemandaService
  include Rails.application.routes.url_helpers

  MAX_OPENAI_RETRIES = 8
  OPENAI_BACKOFF_BASE = 1.5

  def initialize(act_archivo)
    @act_archivo = act_archivo
    raise ActiveRecord::RecordNotFound unless @act_archivo.persisted?

    @identificadores = { demandantes: {}, demandados: {}, testigos: {} }
    @contadores      = { demandantes: 0,   demandados: 0,   testigos: 0 }
  end

  def procesar!
    return false unless puede_procesar?

    texto_pdf = extraer_texto_pdf
    return false if texto_pdf.blank?

    generar_lista_participantes(texto_pdf)
    generar_resumen_anonimizado(texto_pdf)
    generar_lista_hechos(texto_pdf)

    adjuntar_archivos_generados
    true
  rescue StandardError => e
    Rails.logger.error("Error en ProcesadorDemandaService: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    false
  end

  private

  def puede_procesar?
    @act_archivo.act_archivo == "demanda" &&
      @act_archivo.pdf.attached? &&
      @act_archivo.persisted?
  end

  def extraer_texto_pdf
    pdf_path = ActiveStorage::Blob.service.path_for(@act_archivo.pdf.key)
    PDF::Reader.new(pdf_path).pages.map(&:text).join("\n")
  rescue StandardError => e
    Rails.logger.error("Error extrayendo texto del PDF: #{e.message}")
    nil
  end

  # app/services/procesador_demanda_service.rb
  def chat_with_retry(parameters)
    retries = 0
    begin
      cliente_openai.chat(parameters: parameters)
    rescue Faraday::Error => e
      # e.response es un Hash
      status = e.response&.dig(:status) || e.response&.dig("status")
      raise unless [429, 500, 502, 503, 504].include?(status)
      raise if retries >= MAX_OPENAI_RETRIES

      wait = OPENAI_BACKOFF_BASE * (2**retries)
      Rails.logger.warn("OpenAI #{status} – retry #{retries + 1}/#{MAX_OPENAI_RETRIES} after #{wait}s")
      sleep(wait)
      retries += 1
      retry
    end
  end

  # --------------------------------------------------
  # Generación de documentos
  # --------------------------------------------------
  def generar_lista_participantes(texto)
    prompt = build_participantes_prompt(texto)
    respuesta = chat_with_retry(
      model: "gpt-4",
      messages: [{ role: "user", content: prompt }],
      temperature: 0.3
    )
    participantes = JSON.parse(respuesta.dig("choices", 0, "message", "content"))
    asignar_identificadores(participantes)
    @documento_participantes = crear_documento_participantes(participantes)
  end

  def generar_resumen_anonimizado(texto)
    prompt = build_resumen_prompt(texto)
    respuesta = chat_with_retry(
      model: "gpt-4",
      messages: [{ role: "user", content: prompt }],
      temperature: 0.3
    )
    @documento_resumen = respuesta.dig("choices", 0, "message", "content")
  end

  def generar_lista_hechos(texto)
    prompt = build_hechos_prompt(texto)
    respuesta = chat_with_retry(
      model: "gpt-4",
      messages: [{ role: "user", content: prompt }],
      temperature: 0.3
    )
    @documento_hechos = respuesta.dig("choices", 0, "message", "content")
  end

  # --------------------------------------------------
  # Armado de prompts
  # --------------------------------------------------
  def build_participantes_prompt(texto)
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
      #{texto}

      Devuelve la información en formato JSON con esta estructura:
      {
        "demandantes": [{"nombre": "...", "identificacion": "..."}],
        "demandados":  [{"nombre": "...", "identificacion": "..."}],
        "testigos":    [{"nombre": "...", "identificacion": "..."}]
      }
    PROMPT
  end

  def build_resumen_prompt(texto)
    <<~PROMPT
      Basándote en el siguiente texto de demanda, crea un resumen que incluya:

      1. Identificación de demandantes (usa los identificadores proporcionados)
      2. Montos demandados detallados por concepto

      Usa estos identificadores para anonimizar:
      #{@identificadores[:demandantes].to_json}

      Texto de la demanda:
      #{texto}

      Devuelve el resumen en formato de texto estructurado.
    PROMPT
  end

  def build_hechos_prompt(texto)
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
      #{texto}
    PROMPT
  end

  # --------------------------------------------------
  # Lógica de identificadores
  # --------------------------------------------------
  def asignar_identificadores(participantes)
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
  end

  def crear_documento_participantes(participantes)
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
    lines.join("\n")
  end

  # --------------------------------------------------
  # Adjuntar / guardar resultados
  # --------------------------------------------------
  def adjuntar_archivos_generados
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
  end

  def crear_act_texto(tipo:, titulo:, contenido:)
    act_texto = @act_archivo.act_textos.find_or_initialize_by(tipo_documento: tipo)
    act_texto.titulo   = titulo
    act_texto.contenido = contenido
    act_texto.metadata = {
      identificadores: @identificadores,
      procesado_en: Time.current,
      version: (act_texto.version || 0) + 1
    }
    act_texto.save!
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
  # Cliente OpenAI
  # --------------------------------------------------
  def cliente_openai
    @cliente_openai ||= OpenAI::Client.new
  end
end