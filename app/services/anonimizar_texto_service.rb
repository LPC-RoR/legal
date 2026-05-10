# app/services/anonimizar_texto_service.rb
class AnonimizarTextoService
  include PdfExtractor
  include AnonimizacionPrompt  # ← Módulo compartido de prompts
  
  class OpenAIError < StandardError; end
  class ExtraccionError < StandardError; end

  MODELO = "gpt-4o".freeze
  TEMPERATURA = 0.1

  def initialize(act_archivo, nombres_anonimizar = {})
    @act_archivo = act_archivo
    @nombres_anonimizar = normalizar_hash_nombres(nombres_anonimizar)
    @client = OpenAI::Client.new
  end

  def anonimizar!
    texto_pdf = extraer_texto_pdf(@act_archivo)
    raise ExtraccionError, "No se pudo extraer texto del PDF" if texto_pdf.blank?

    Rails.logger.info "[AnonimizarTextoService] Texto extraído: #{texto_pdf.length} caracteres"

    texto_anonimizado = solicitar_anonimizacion_a_openai(texto_pdf)
    guardar_texto_anonimizado!(texto_anonimizado)
  end

  private

  def normalizar_hash_nombres(hash)
    hash.transform_keys { |k| k.to_s.unicode_normalize(:nfc) }
  end

  def solicitar_anonimizacion_a_openai(texto_pdf)
    system_prompt = <<~PROMPT
      Eres un asistente especializado en procesamiento de documentos jurídicos.
      Tu única tarea es anonimizar un documento reemplazando datos personales por etiquetas estandarizadas.
      
      REGLAS OBLIGATORIAS:
      1. Mantén TODO el texto original, palabra por palabra, excepto los datos personales a reemplazar.
      2. Conserva el formato, párrafos, saltos de línea y estructura del documento original.
      3. NO resumas. NO omitas contenido. NO agregues comentarios.
      4. Devuelve el resultado en HTML válido: <p> para párrafos, <br> para saltos de línea.
      5. NO uses markdown. NO incluyas <html>, <head>, <body>. Solo el contenido dentro de <article>.
    PROMPT

    # Usa el método del módulo compartido
    user_prompt = construir_prompt_anonimizacion(texto_pdf, @nombres_anonimizar)

    response = @client.chat(
      parameters: {
        model: MODELO,
        messages: [
          { role: "system", content: system_prompt },
          { role: "user", content: user_prompt }
        ],
        temperature: TEMPERATURA,
        max_tokens: 8000
      }
    )

    contenido = response.dig("choices", 0, "message", "content")
    raise OpenAIError, "Respuesta vacía de OpenAI" if contenido.blank?

    limpiar_html(contenido)
  rescue OpenAI::Error => e
    Rails.logger.error "[AnonimizarTextoService] Error OpenAI: #{e.message}"
    raise OpenAIError, "Error en la API de OpenAI: #{e.message}"
  end

  def limpiar_html(contenido)
    contenido.gsub(/```html\s*/, '').gsub(/```\s*/, '').strip
  end

  def guardar_texto_anonimizado!(contenido_html)
    KrnTexto.find_or_initialize_by(
      ownr: @act_archivo,
      codigo: "texto_anonimizado"
    ).tap do |krn_texto|
      krn_texto.assign_attributes(
        titulo: "Texto anonimizado - #{@act_archivo.pdf.filename.to_s}",
        contenido: contenido_html
      )
      krn_texto.save!
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "[AnonimizarTextoService] Error guardando KrnTexto: #{e.message}"
    raise
  end
end