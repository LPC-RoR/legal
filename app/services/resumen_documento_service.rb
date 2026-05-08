# app/services/resumen_documento_service.rb
class ResumenDocumentoService
  include PdfExtractor  # ← Incluye el módulo
  
  class OpenAIError < StandardError; end
  class ExtraccionError < StandardError; end

  MODELO = "gpt-4o".freeze
  TEMPERATURA = 0.3

  def initialize(act_archivo, nombres_anonimizar = {})
    @act_archivo = act_archivo
    @nombres_anonimizar = normalizar_hash_nombres(nombres_anonimizar)
    @client = OpenAI::Client.new
  end

  def generar_resumen!
    texto_pdf = extraer_texto_pdf(@act_archivo)  # ← Llama al método del módulo
    raise ExtraccionError, "No se pudo extraer texto del PDF" if texto_pdf.blank?

    Rails.logger.info "[ResumenDocumentoService] Texto extraído: #{texto_pdf.length} caracteres"

    resumen_html = solicitar_resumen_a_openai(texto_pdf)
    guardar_resumen!(resumen_html)
  end

  private

  def normalizar_hash_nombres(hash)
    hash.transform_keys { |k| k.to_s.unicode_normalize(:nfc) }
  end

  def solicitar_resumen_a_openai(texto_pdf)
    system_prompt = <<~PROMPT
      Eres un asistente jurídico especializado en análisis de documentos de denuncias y declaraciones.
      Tu tarea es generar un resumen cronológico, objetivo y estructurado de los hechos contenidos en el documento.
      
      REGLAS OBLIGATORIAS:
      1. Ordena los hechos estrictamente por orden cronológico (de más antiguo a más reciente).
      2. Usa un tono formal, neutral y descriptivo. No emitas juicios de valor.
      3. Anonimiza TODOS los nombres propios de personas usando los alias proporcionados.
      4. Si no se proporciona alias para un nombre, reemplázalo por "[Persona X]" donde X es una letra secuencial.
      5. Omite datos personales sensibles: RUT, direcciones exactas, teléfonos, correos electrónicos.
      6. El resumen debe ser conciso pero completo: incluye fechas, lugares y descripción de los hechos.
      
      FORMATO DE SALIDA (MUY IMPORTANTE):
      - Devuelve el resumen en HTML válido y bien formateado.
      - Usa etiquetas semánticas: <h2> para el título, <h3> para fechas/etapas, <p> para párrafos, <ul>/<li> para listas.
      - NO uses markdown. Solo HTML puro.
      - NO incluyas <html>, <head>, <body>. Solo el contenido del resumen dentro de un <article>.
    PROMPT

    user_prompt = construir_user_prompt(texto_pdf)

    response = @client.chat(
      parameters: {
        model: MODELO,
        messages: [
          { role: "system", content: system_prompt },
          { role: "user", content: user_prompt }
        ],
        temperature: TEMPERATURA,
        max_tokens: 4000
      }
    )

    contenido = response.dig("choices", 0, "message", "content")
    raise OpenAIError, "Respuesta vacía de OpenAI" if contenido.blank?

    limpiar_html(contenido)
  rescue OpenAI::Error => e
    Rails.logger.error "[ResumenDocumentoService] Error OpenAI: #{e.message}"
    raise OpenAIError, "Error en la API de OpenAI: #{e.message}"
  end

  def construir_user_prompt(texto_pdf)
    prompt = <<~PROMPT
      DOCUMENTO A RESUMIR:

      #{texto_pdf}

    PROMPT

    if @nombres_anonimizar.any?
      prompt << <<~MAPA
        MAPA DE ANONIMIZACIÓN (usa estos alias cuando encuentres los nombres correspondientes):
      MAPA
      
      @nombres_anonimizar.each do |nombre_real, alias_anonimo|
        prompt << "- \"#{nombre_real}\" → \"#{alias_anonimo}\"\n"
      end
      
      prompt << <<~INSTRUCCIONES
        
        INSTRUCCIONES DE ANONIMIZACIÓN:
        - Si encuentras en el documento los nombres del mapa anterior, reemplázalos por sus alias.
        - Si encuentras otros nombres propios de personas NO listados en el mapa, anonimízalos así:
          * Quien presenta la denuncia → "Denunciante"
          * Contra quien se dirige la denuncia → "Denunciado"  
          * Testigos u otros mencionados → "Testigo A", "Testigo B", etc.
        - Si no puedes determinar el rol, usa "Persona A", "Persona B", etc.
      INSTRUCCIONES
    else
      prompt << <<~INSTRUCCIONES
        
        INSTRUCCIONES DE ANONIMIZACIÓN:
        - Anonimiza TODOS los nombres propios de personas:
          * Quien presenta la denuncia → "Denunciante"
          * Contra quien se dirige la denuncia → "Denunciado"
          * Testigos u otros mencionados → "Testigo A", "Testigo B", etc.
      INSTRUCCIONES
    end

    prompt << "\nGenera ahora el resumen cronológico anonimizado en español formal, con formato HTML."
    prompt
  end

  def limpiar_html(contenido)
    contenido.gsub(/```html\s*/, '').gsub(/```\s*/, '').strip
  end

  def guardar_resumen!(contenido_html)
    KrnTexto.find_or_initialize_by(
      ownr: @act_archivo,
      codigo: "resumen_cronologico"
    ).tap do |krn_texto|
      krn_texto.assign_attributes(
        titulo: "Resumen cronológico - #{@act_archivo.pdf.filename.to_s}",
        contenido: contenido_html
      )
      krn_texto.save!
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "[ResumenDocumentoService] Error guardando KrnTexto: #{e.message}"
    raise
  end
end