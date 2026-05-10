# app/services/anonimizar_krn_texto_service.rb
class AnonimizarKrnTextoService
  include TextExtractor  # ← Usa el nuevo módulo para texto plano
  
  class OpenAIError < StandardError; end
  class ExtraccionError < StandardError; end

  MODELO = "gpt-4o".freeze
  TEMPERATURA = 0.1

  def initialize(krn_texto_origen, nombres_anonimizar = {})
    @krn_texto_origen = krn_texto_origen
    @nombres_anonimizar = normalizar_hash_nombres(nombres_anonimizar)
    @client = OpenAI::Client.new
  end

  def anonimizar!
    texto_plano = extraer_texto_plano(@krn_texto_origen)
    raise ExtraccionError, "No se pudo extraer texto del KrnTexto origen" if texto_plano.blank?

    Rails.logger.info "[AnonimizarKrnTextoService] Texto extraído: #{texto_plano.length} caracteres"

    texto_anonimizado_html = solicitar_anonimizacion_a_openai(texto_plano)
    guardar_texto_anonimizado!(texto_anonimizado_html)
  end

  private

  def normalizar_hash_nombres(hash)
    hash.transform_keys { |k| k.to_s.unicode_normalize(:nfc) }
  end

  def solicitar_anonimizacion_a_openai(texto_plano)
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

    user_prompt = construir_user_prompt(texto_plano)

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
    Rails.logger.error "[AnonimizarKrnTextoService] Error OpenAI: #{e.message}"
    raise OpenAIError, "Error en la API de OpenAI: #{e.message}"
  end

  def construir_user_prompt(texto_plano)
    prompt = +"DOCUMENTO A ANONIMIZAR (mantén TODO el texto, solo reemplaza nombres):\n\n#{texto_plano}\n\n"

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

  # El nuevo KrnTexto tiene el MISMO ownr que el origen
  def guardar_texto_anonimizado!(contenido_html)
    KrnTexto.find_or_initialize_by(
      ownr: @krn_texto_origen.ownr,  # ← Mismo ownr que el origen
      codigo: "texto_anonimizado"
    ).tap do |krn_texto|
      krn_texto.assign_attributes(
        titulo: "Texto anonimizado - #{@krn_texto_origen.titulo}",
        contenido: contenido_html
      )
      krn_texto.save!
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "[AnonimizarKrnTextoService] Error guardando KrnTexto: #{e.message}"
    raise
  end
end