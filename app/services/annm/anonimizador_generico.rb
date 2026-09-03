# app/services/annm/anonimizador_generico.rb
module Annm
  class AnonimizadorGenerico
    PROMPT_TEMPLATE = <<~PROMPT
      El siguiente texto ya ha sido parcialmente anonimizado. Contiene placeholders de participantes como [CI-DN-001], [DN-001], [EMAIL-DD-002], [CARGO-TG-001], etc.
      NO debes modificar estos placeholders bajo ninguna circunstancia.

      Tu tarea es identificar y reemplazar ÚNICAMENTE los elementos que aún no estén anonimizados:

      1. Cédulas de identidad o RUT chilenos (formatos: XX.XXX.XXX-X, XXXXXXXX-X, XXXXXXXXX) → [CI|RUT]
      2. Nombres propios de personas (completos, parciales, compuestos) → [NOMBRE]
      3. Direcciones de correo electrónico → [EMAIL]
      4. Cargos o puestos laborales → [CARGO]
      5. Profesiones u oficios → [PROFESION]

      REGLAS ESTRICTAS:
      - Conserva exactamente todos los placeholders existentes.
      - No modifiques atributos HTML ni etiquetas.
      - No agregues explicaciones, comentarios ni markdown.
      - Devuelve ÚNICAMENTE el texto procesado.

      TEXTO:
      %s
    PROMPT

    def initialize(api_key = nil)
      @api_key = api_key || Rails.application.credentials.openai_api_key
    end

    def anonimizar(texto)
      return texto if texto.blank? || @api_key.blank?

      # Truncar si es excesivamente largo para no quemar tokens
      texto_prompt = texto.length > 12_000 ? texto[0..12_000] + "\n[...]" : texto
      prompt = format(PROMPT_TEMPLATE, texto_prompt)

      cliente = OpenAI::Client.new(access_token: @api_key)

      respuesta = cliente.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [{ role: "user", content: prompt }],
          temperature: 0.0,
          max_tokens: 4000
        }
      )

      resultado = respuesta.dig("choices", 0, "message", "content")
      resultado.present? ? resultado.strip : texto
    rescue => e
      Rails.logger.error "[Annm::AnonimizadorGenerico] #{e.class}: #{e.message}"
      texto
    end
  end
end