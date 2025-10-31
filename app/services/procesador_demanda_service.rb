# app/services/procesador_demanda_service.rb
class ProcesadorDemandaService
  include Rails.application.routes.url_helpers

  def initialize(act_archivo)
    @act_archivo = act_archivo

    # Verificar que el registro existe
    raise ActiveRecord::RecordNotFound unless @act_archivo.persisted?

    @identificadores = {
      demandantes: {},
      demandados: {},
      testigos: {}
    }
    @contadores = {
      demandantes: 0,
      demandados: 0,
      testigos: 0
    }
  end

  def procesar!
    # Verificar condiciones antes de procesar
    return false unless puede_procesar?

    texto_pdf = extraer_texto_pdf
    return if texto_pdf.blank?

    # Generar los tres documentos
    generar_lista_participantes(texto_pdf)
    generar_resumen_anonimizado(texto_pdf)
    generar_lista_hechos(texto_pdf)

    # Adjuntar los archivos generados al modelo
    adjuntar_archivos_generados
    
    true
  rescue => e
    Rails.logger.error "Error en ProcesadorDemandaService: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    false
  end

  private

  def puede_procesar?
    @act_archivo.act_archivo == "demanda" && 
    @act_archivo.pdf.attached? && 
    @act_archivo.persisted?
  end

  def extraer_texto_pdf
    # Descargar y extraer texto del PDF
    pdf_path = ActiveStorage::Blob.service.path_for(@act_archivo.pdf.key)
    reader = PDF::Reader.new(pdf_path)
    reader.pages.map(&:text).join("\n")
  rescue => e
    Rails.logger.error "Error extrayendo texto del PDF: #{e.message}"
    nil
  end

  def generar_lista_participantes(texto)
    prompt = <<~PROMPT
      Analiza el siguiente texto de una demanda legal y extrae:
      1. Todos los demandantes con sus cédulas/RUN/RUT
      2. Todos los demandados con sus cédulas/RUN/RUT  
      3. Todos los testigos con sus cédulas/RUN/RUT

      Para cada persona, necesito:
      - Nombre completo
      - Cédula de identidad/RUN/RUT
      - Rol (demandante/demandado/testigo)

      Texto de la demanda:
      #{texto}

      Devuelve la información en formato JSON con esta estructura:
      {
        "demandantes": [{"nombre": "...", "identificacion": "..."}],
        "demandados": [{"nombre": "...", "identificacion": "..."}],
        "testigos": [{"nombre": "...", "identificacion": "..."}]
      }
    PROMPT

    respuesta = cliente_openai.chat(
      parameters: {
        model: "gpt-4",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.3
      }
    )

    participantes = JSON.parse(respuesta.dig("choices", 0, "message", "content"))
    
    # Generar identificadores únicos
    asignar_identificadores(participantes)
    
    # Crear documento de lista de participantes
    @documento_participantes = crear_documento_participantes(participantes)
  end

  def asignar_identificadores(participantes)
    participantes["demandantes"].each_with_index do |demandante, index|
      @contadores[:demandantes] += 1
      id = "DNNCNT-#{@contadores[:demandantes]}"
      @identificadores[:demandantes][demandante["nombre"]] = id
    end

    participantes["demandados"].each_with_index do |demandado, index|
      @contadores[:demandados] += 1
      id = "DNNCD-#{@contadores[:demandados]}"
      @identificadores[:demandados][demandado["nombre"]] = id
    end

    participantes["testigos"].each_with_index do |testigo, index|
      @contadores[:testigos] += 1
      id = "TSTG-#{@contadores[:testigos]}"
      @identificadores[:testigos][testigo["nombre"]] = id
    end
  end

  def crear_documento_participantes(participantes)
    contenido = "LISTA DE PARTICIPANTES - DEMANDA\n"
    contenido += "=====================================\n\n"

    contenido += "DEMANDANTES:\n"
    participantes["demandantes"].each do |demandante|
      id = @identificadores[:demandantes][demandante["nombre"]]
      contenido += "- #{id}: #{demandante["nombre"]} - #{demandante["identificacion"]}\n"
    end

    contenido += "\nDEMANDADOS:\n"
    participantes["demandados"].each do |demandado|
      id = @identificadores[:demandados][demandado["nombre"]]
      contenido += "- #{id}: #{demandado["nombre"]} - #{demandado["identificacion"]}\n"
    end

    contenido += "\nTESTIGOS:\n"
    participantes["testigos"].each do |testigo|
      id = @identificadores[:testigos][testigo["nombre"]]
      contenido += "- #{id}: #{testigo["nombre"]} - #{testigo["identificacion"]}\n"
    end

    contenido
  end

  def generar_resumen_anonimizado(texto)
    prompt = <<~PROMPT
      Basándote en el siguiente texto de demanda, crea un resumen que incluya:

      1. Identificación de demandantes (usa los identificadores proporcionados)
      2. Montos demandados detallados por concepto

      Usa estos identificadores para anonimizar:
      #{@identificadores[:demandantes].to_json}

      Texto de la demanda:
      #{texto}

      Devuelve el resumen en formato de texto estructurado.
    PROMPT

    respuesta = cliente_openai.chat(
      parameters: {
        model: "gpt-4",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.3
      }
    )

    @documento_resumen = respuesta.dig("choices", 0, "message", "content")
  end

  def generar_lista_hechos(texto)
    prompt = <<~PROMPT
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

    respuesta = cliente_openai.chat(
      parameters: {
        model: "gpt-4",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.3
      }
    )

    @documento_hechos = respuesta.dig("choices", 0, "message", "content")
  end

  def adjuntar_archivos_generados
    # Guardar y adjuntar lista de participantes
    participantes_io = StringIO.new(@documento_participantes)
    @act_archivo.lista_participantes.attach(
      io: participantes_io,
      filename: "lista_participantes_#{@act_archivo.id}.txt",
      content_type: "text/plain"
    )

    # Guardar y adjuntar resumen
    resumen_io = StringIO.new(@documento_resumen)
    @act_archivo.resumen_anonimizado.attach(
      io: resumen_io,
      filename: "resumen_anonimizado_#{@act_archivo.id}.txt",
      content_type: "text/plain"
    )

    # Guardar y adjuntar lista de hechos
    hechos_io = StringIO.new(@documento_hechos)
    @act_archivo.lista_hechos.attach(
      io: hechos_io,
      filename: "lista_hechos_#{@act_archivo.id}.txt",
      content_type: "text/plain"
    )
  end

  def cliente_openai
    @cliente_openai ||= OpenAI::Client.new
  end

  def adjuntar_archivos_generados
    # Crear ActTexto para lista de participantes
    crear_act_texto(
      tipo: 'lista_participantes',
      titulo: "Lista de Participantes - Demanda #{@act_archivo.id}",
      contenido: formatear_contenido_lista_participantes
    )

    # Crear ActTexto para resumen anonimizado
    crear_act_texto(
      tipo: 'resumen_anonimizado', 
      titulo: "Resumen Anonimizado - Demanda #{@act_archivo.id}",
      contenido: formatear_contenido_resumen
    )

    # Crear ActTexto para lista de hechos
    crear_act_texto(
      tipo: 'lista_hechos',
      titulo: "Lista de Hechos - Demanda #{@act_archivo.id}", 
      contenido: formatear_contenido_hechos
    )
  end

  private

  def crear_act_texto(tipo:, titulo:, contenido:)
    act_texto = @act_archivo.act_textos.find_or_initialize_by(
      tipo_documento: tipo
    )
    act_texto.titulo = titulo
    act_texto.contenido = contenido
    act_texto.metadata = {
      identificadores: @identificadores,
      procesado_en: Time.current,
      version: act_texto.version.to_i + 1
    }
    act_texto.save!
  end

  def formatear_contenido_lista_participantes
    contenido = "<h1>Lista de Participantes - Demanda</h1>"
    contenido += "<hr>"
    # Formatear el contenido con HTML para ActionText
    # ... (lógica de formateo) ...
    contenido
  end

  def formatear_contenido_resumen
    # Similar al anterior pero para resumen
    "<h1>Resumen Anonimizado</h1><hr>#{@documento_resumen}"
  end

  def formatear_contenido_hechos
    # Similar para hechos
    "<h1>Lista de Hechos</h1><hr>#{@documento_hechos}"
  end
end