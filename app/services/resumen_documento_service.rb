# app/services/resumen_documento_service.rb
class ResumenDocumentoService
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
    texto_pdf = extraer_texto_pdf
    raise ExtraccionError, "No se pudo extraer texto del PDF" if texto_pdf.blank?

    texto_pdf = texto_pdf.unicode_normalize(:nfc)
    
    Rails.logger.info "[ResumenDocumentoService] Texto extraído: #{texto_pdf.length} caracteres"
    Rails.logger.debug "[ResumenDocumentoService] Primeros 500 chars: #{texto_pdf[0..500]}"

    resumen = solicitar_resumen_a_openai(texto_pdf)
    guardar_resumen!(resumen)
  end

  private

  def normalizar_hash_nombres(hash)
    hash.transform_keys { |k| k.to_s.unicode_normalize(:nfc) }
  end

  def extraer_texto_pdf
    return nil unless @act_archivo.pdf.attached?

    pdf_blob = @act_archivo.pdf.download
    reader = PDF::Reader.new(StringIO.new(pdf_blob))
    texto = reader.pages.map(&:text).join("\n")
    
    Rails.logger.info "=== DEBUG PDF ==="
    Rails.logger.info "Texto primeros 200 chars: #{texto[0..200]}"
    Rails.logger.info "Texto bytes: #{texto[0..50].bytes.inspect}"
    
    texto.unicode_normalize(:nfc)
  rescue PDF::Reader::MalformedPDFError, PDF::Reader::UnsupportedFeatureError => e
    Rails.logger.error "[ResumenDocumentoService] Error leyendo PDF: #{e.message}"
    nil
  rescue => e
    Rails.logger.error "[ResumenDocumentoService] Error inesperado extrayendo PDF: #{e.message}"
    nil
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
      7. Si el documento no contiene hechos concretos, indica: "El documento no contiene relato de hechos identificables."
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

    contenido
  rescue OpenAI::Error => e
    Rails.logger.error "[ResumenDocumentoService] Error OpenAI: #{e.message}"
    raise OpenAIError, "Error en la API de OpenAI: #{e.message}"
  end

  def construir_user_prompt(texto_pdf)
    prompt = +"DOCUMENTO A RESUMIR:\n\n#{texto_pdf}\n\n"

    if @nombres_anonimizar.any?
      prompt << "MAPA DE ANONIMIZACIÓN (reemplaza EXACTAMENTE estos nombres por los alias indicados):\n"
      @nombres_anonimizar.each do |nombre_real, alias_anonimo|
        prompt << "- \"#{nombre_real}\" → \"#{alias_anonimo}\"\n"
      end
      prompt << "\n"
    end

    prompt << "INSTRUCCIONES FINALES:\n"
    prompt << "- Reemplaza cada nombre del mapa por su alias correspondiente en todo el resumen.\n"
    prompt << "- Si encuentras variantes o abreviaciones de los nombres (ej: 'María' en lugar de 'María Belén Leiva Olea'), anonimízalas también.\n"
    prompt << "- Genera el resumen cronológico en español formal.\n"

    prompt
  end

  def guardar_resumen!(contenido_resumen)
    KrnTexto.find_or_initialize_by(
      ownr: @act_archivo,
      codigo: "resumen_cronologico"
    ).tap do |krn_texto|
      krn_texto.assign_attributes(
        titulo: "Resumen cronológico - #{@act_archivo.pdf.filename.to_s}",
        contenido: contenido_resumen
      )
      krn_texto.save!
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "[ResumenDocumentoService] Error guardando KrnTexto: #{e.message}"
    raise
  end
end