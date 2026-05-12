# app/services/confirmar_hechos_service.rb
class ConfirmarHechosService
  include TextExtractor
  include PdfExtractor
  
  class OpenAIError < StandardError; end
  class ExtraccionError < StandardError; end

  MODELO = "gpt-4o".freeze
  TEMPERATURA = 0.1

  def initialize(krn_texto_declaracion, act_archivo_denuncia, nombres_anonimizar: {}, tipo_declarante:, nombres_denunciantes: [], nombres_denunciados: [])
    @krn_texto_declaracion = krn_texto_declaracion
    @act_archivo_denuncia = act_archivo_denuncia
    @nombres_anonimizar = normalizar_hash_nombres(nombres_anonimizar)
    @tipo_declarante = tipo_declarante
    @nombres_denunciantes = nombres_denunciantes
    @nombres_denunciados = nombres_denunciados
    @client = OpenAI::Client.new
  end

  def generar_reporte!
    texto_declaracion = extraer_texto_plano(@krn_texto_declaracion)
    texto_denuncia = extraer_texto_pdf(@act_archivo_denuncia)

    raise ExtraccionError, "No se pudo extraer texto de la declaración" if texto_declaracion.blank?
    raise ExtraccionError, "No se pudo extraer texto de la denuncia" if texto_denuncia.blank?

    Rails.logger.info "[ConfirmarHechosService] Tipo: #{@tipo_declarante} | Denunciantes: #{@nombres_denunciantes} | Denunciados: #{@nombres_denunciados}"

    # Extrae hechos estructurados de ambos documentos
    hechos_denuncia = extraer_hechos(texto_denuncia, "denuncia")
    hechos_declaracion = extraer_hechos(texto_declaracion, "declaracion")

    Rails.logger.info "[ConfirmarHechosService] Hechos denuncia: #{hechos_denuncia.length} | Hechos declaración: #{hechos_declaracion.length}"

    # Compara según tipo de declarante
    confirmados, adicionales = comparar_hechos(hechos_denuncia, hechos_declaracion)

    Rails.logger.info "[ConfirmarHechosService] Confirmados: #{confirmados.length} | Adicionales: #{adicionales.length}"

    reporte_html = generar_html(confirmados, adicionales)
    guardar_reporte!(reporte_html)
  end

  private

  def normalizar_hash_nombres(hash)
    hash.transform_keys { |k| k.to_s.unicode_normalize(:nfc) }
  end

  def extraer_hechos(texto, tipo)
    prompt = <<~PROMPT
      Extrae los HECHOS CONCRETOS de esta #{tipo.upcase}.

      Un hecho concreto tiene: fecha (o período), descripción objetiva, personas involucradas.
      NO incluyas opiniones, sentimientos, conclusiones jurídicas ni solicitudes.

      FORMATO (JSON):
      [
        {"fecha": "9 de marzo 2026", "descripcion": "...", "personas": ["nombre1", "nombre2"]}
      ]
      Si no hay hechos: []

      #{reglas_anonimizacion}

      === TEXTO ===
      #{truncar(texto, 5000)}

      Responde ÚNICAMENTE con el JSON.
    PROMPT

    respuesta = llamar_openai(prompt, 3000)
    parsear_json(respuesta)
  end

  def comparar_hechos(hechos_denuncia, hechos_declaracion)
    prompt = <<~PROMPT
      Compara hechos de DENUNCIA vs DECLARACIÓN.

      CONTEXTO:
      - Tipo de declarante: #{@tipo_declarante.upcase}
      - Denunciantes: #{@nombres_denunciantes.join(", ")}
      - Denunciados: #{@nombres_denunciados.join(", ")}

      #{instrucciones_por_tipo}

      HECHOS DENUNCIA:
      #{hechos_denuncia.to_json}

      HECHOS DECLARACIÓN:
      #{hechos_declaracion.to_json}

      FORMATO (JSON):
      {
        "confirmados": [
          {"fecha": "...", "descripcion": "...", "fundamento": "por qué está confirmado"}
        ],
        "adicionales": [
          {"fecha": "...", "descripcion": "...", "fundamento": "por qué es adicional"}
        ]
      }

      Responde ÚNICAMENTE con el JSON.
    PROMPT

    respuesta = llamar_openai(prompt, 3000)
    resultado = parsear_json(respuesta)
    
    [resultado["confirmados"] || [], resultado["adicionales"] || []]
  end

  def instrucciones_por_tipo
    case @tipo_declarante
    when "denunciante"
      <<~TXT
        INSTRUCCIONES (DENUNCIANTE):
        - CONFIRMA: hechos donde él/ella fue víctima, presenció o participó.
        - NO confirma hechos que solo involucran a otros (a menos que los presenció).
        - ADICIONALES: detalles nuevos de su experiencia, hechos posteriores a la denuncia.
      TXT
    when "denunciado"
      <<~TXT
        INSTRUCCIONES (DENUNCIADO):
        - CONFIRMA: hechos que admite o no niega explícitamente.
        - NO confirma hechos que niega, justifica o reinterpreta.
        - ADICIONALES: su versión de los hechos, contexto que la denuncia omite.
      TXT
    when "testigo"
      <<~TXT
        INSTRUCCIONES (TESTIGO):
        - CONFIRMA: hechos que presenció DIRECTAMENTE (estaba presente).
        - NO confirma hechos que conoce de oídas (a menos que cite fuente).
        - ADICIONALES: hechos que presenció y no están en la denuncia.
      TXT
    else
      <<~TXT
        INSTRUCCIONES:
        - CONFIRMA: hechos que el declarante valida explícitamente.
        - ADICIONALES: hechos nuevos que aporta.
      TXT
    end
  end

  def generar_html(confirmados, adicionales)
    c_html = confirmados.map { |h| "<li><strong>#{h['fecha']}:</strong> #{h['descripcion']}</li>" }.join
    a_html = adicionales.map { |h| "<li><strong>#{h['fecha']}:</strong> #{h['descripcion']}</li>" }.join

    <<~HTML
      <article>
        <h2>Hechos confirmados por la declaración</h2>
        <p><em>Declarante: #{@tipo_declarante.upcase}</em></p>
        #{confirmados.any? ? "<ul>#{c_html}</ul>" : '<p><em>La declaración no confirma hechos de la denuncia.</em></p>'}

        <h2>Hechos adicionales aportados por la declaración</h2>
        #{adicionales.any? ? "<ul>#{a_html}</ul>" : '<p><em>La declaración no aporta hechos adicionales.</em></p>'}
      </article>
    HTML
  end

  def llamar_openai(prompt, max_tokens)
    response = @client.chat(
      parameters: {
        model: MODELO,
        messages: [{ role: "user", content: prompt }],
        temperature: TEMPERATURA,
        max_tokens: max_tokens
      }
    )
    response.dig("choices", 0, "message", "content")&.strip || raise(OpenAIError, "Vacío")
  rescue OpenAI::Error => e
    Rails.logger.error "[ConfirmarHechosService] Error OpenAI: #{e.message}"
    raise OpenAIError, e.message
  end

  def parsear_json(respuesta)
    json = respuesta.gsub(/```json\s*/, '').gsub(/```\s*/, '').strip
    return [] if json == "[]" || json.blank?
    JSON.parse(json)
  rescue JSON::ParserError
    Rails.logger.error "[ConfirmarHechosService] JSON inválido: #{respuesta[0..100]}"
    {}
  end

  def reglas_anonimizacion
    r = +""
    if @nombres_anonimizar.any?
      r << "MAPA DE NOMBRES:\n"
      @nombres_anonimizar.each { |k, v| r << "- \"#{k}\" → \"#{v}\"\n" }
    end
    r << <<~TXT
      - Denunciantes → "Denunciante 1", "Denunciante 2", etc.
      - Denunciados → "Denunciado 1", "Denunciado 2", etc.
      - Testigos → "Testigo A", "Testigo B", etc.
      - RUT (XX.XXX.XXX-Y) → "[CEDULA DE IDENTIDAD/RUT]"
      - Emails → "[EMAIL]"
    TXT
    r
  end

  def truncar(texto, max)
    return texto if texto.length <= max
    t = texto[0...max]
    p = t.rindex(/[.]\s/) || t.rindex("\n")
    p ? t[0..p] : t
  end

  def guardar_reporte!(html)
    KrnTexto.find_or_initialize_by(
      ownr: @krn_texto_declaracion.ownr,
      codigo: "confirmacion_hechos"
    ).tap do |k|
      k.assign_attributes(
        titulo: "Confirmación de hechos - #{@krn_texto_declaracion.titulo}",
        contenido: html
      )
      k.save!
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "[ConfirmarHechosService] Error guardando: #{e.message}"
    raise
  end
end