# app/services/anonimizar_texto_service.rb
class AnonimizarTextoService
  include PdfExtractor  # ← Incluye el módulo
  
  class OpenAIError < StandardError; end
  class ExtraccionError < StandardError; end

  MODELO = "gpt-4o".freeze
  TEMPERATURA = 0.1  # Muy baja: tarea mecánica, no creativa

  def initialize(act_archivo, nombres_anonimizar = {})
    @act_archivo = act_archivo
    @nombres_anonimizar = normalizar_hash_nombres(nombres_anonimizar)
    @client = OpenAI::Client.new
  end

  def anonimizar!
    texto_pdf = extraer_texto_pdf(@act_archivo)  # ← Llama al método del módulo
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
      Tu única tarea es anonimizar un documento reemplazando nombres propios de personas por alias.

      REGLAS OBLIGATORIAS:
      1. Mantén TODO el texto original, palabra por palabra, excepto los nombres a reemplazar.
      2. Conserva el formato, párrafos, saltos de línea y estructura del documento original.
      3. Reemplaza los nombres del mapa por sus alias exactos.
      4. Si encuentras otros nombres propios no listados, reemplázalos por "[Persona A]", "[Persona B]", etc.
      5. NO resumas. NO omitas contenido. NO agregues comentarios.
      6. Omite solo datos personales sensibles: RUT, direcciones exactas, teléfonos, correos electrónicos.
      7. Devuelve el resultado en HTML válido: <p> para párrafos, <br> para saltos de línea, <strong> solo si el original tenía énfasis.
      8. NO uses markdown. NO incluyas <html>, <head>, <body>. Solo el contenido dentro de <article>.
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
        max_tokens: 8000  # Más tokens: texto completo puede ser largo
      }
    )

    contenido = response.dig("choices", 0, "message", "content")
    raise OpenAIError, "Respuesta vacía de OpenAI" if contenido.blank?

    limpiar_html(contenido)
  rescue OpenAI::Error => e
    Rails.logger.error "[AnonimizarTextoService] Error OpenAI: #{e.message}"
    raise OpenAIError, "Error en la API de OpenAI: #{e.message}"
  end

  def construir_user_prompt(texto_pdf)
    prompt = +"DOCUMENTO A ANONIMIZAR (mantén TODO el texto, solo reemplaza nombres):\n\n#{texto_pdf}\n\n"

    if @nombres_anonimizar.any?
      prompt << "MAPA DE ANONIMIZACIÓN (reemplaza EXACTAMENTE estos nombres por los alias indicados):\n"
      @nombres_anonimizar.each do |nombre_real, alias_anonimo|
        prompt << "- \"#{nombre_real}\" → \"#{alias_anonimo}\"\n"
      end
      prompt << "\n"
    end

    prompt << "INSTRUCCIONES FINALES:\n"
    prompt << "- Devuelve el documento COMPLETO anonimizado, sin resumir ni omitir nada.\n"
    prompt << "- Conserva la estructura de párrafos y el formato.\n"
    prompt << "- Usa HTML con <p> para párrafos y <br> para saltos de línea simples.\n"

    prompt
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