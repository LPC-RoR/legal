# app/services/anonimizar_krn_texto_service.rb
class AnonimizarKrnTextoService
  include TextExtractor
  include AnonimizacionPrompt  # ← Módulo compartido de prompts
  
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
      Tu única tarea es anonimizar un documento reemplazando datos personales por etiquetas estandarizadas.
      
      REGLAS OBLIGATORIAS:
      1. Mantén TODO el texto original, palabra por palabra, excepto los datos personales a reemplazar.
      2. Conserva el formato, párrafos, saltos de línea y estructura del documento original.
      3. NO resumas. NO omitas contenido. NO agregues comentarios.
      4. Devuelve el resultado en HTML válido: <p> para párrafos, <br> para saltos de línea.
      5. NO uses markdown. NO incluyas <html>, <head>, <body>. Solo el contenido dentro de <article>.
    PROMPT

    # Usa el método del módulo compartido
    user_prompt = construir_prompt_anonimizacion(texto_plano, @nombres_anonimizar)

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

  def limpiar_html(contenido)
    contenido.gsub(/```html\s*/, '').gsub(/```\s*/, '').strip
  end

  def guardar_texto_anonimizado!(contenido_html)
    KrnTexto.find_or_initialize_by(
      ownr: @krn_texto_origen.ownr,
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