# app/services/annm/anonimizador_generico.rb
module Annm
  class AnonimizadorGenerico
    PROMPT_TEMPLATE = <<~PROMPT
      Eres un sistema forense de anonimización. El texto YA CONTIENE placeholders de participantes como [DN-001], [CI-TG-002], [EMAIL-DD-003], [CARGO-DN-001], [dnncnt-47], etc.

      REGLAS ABSOLUTAS:
      1. NO toques NADA que esté entre corchetes [...].
      2. NO toques palabras que estén INMEDIATAMENTE ANTES o DESPUÉS de un placeholder.
      3. Si una palabra podría ser un nombre pero está cerca de un placeholder, ASUME que ya fue anonimizada.
      4. Sé CONSERVADOR: si tienes duda, NO reemplaces.

      Reemplaza ÚNICAMENTE elementos claramente genéricos y sin placeholder cercano:
      - RUTs chilenos → [CI|RUT]
      - Nombres de personas sin placeholder cercano → [NOMBRE]
      - Emails genéricos → [EMAIL]
      - Cargos genéricos → [CARGO]
      - Profesiones → [PROFESION]

      TEXTO:
      %s

      Devuelve ÚNICAMENTE el texto procesado. Sin explicaciones.
    PROMPT

    def initialize(api_key = nil)
      @api_key = api_key || Rails.application.credentials.openai_api_key
    end

    def anonimizar(texto)
      return texto if texto.blank? || @api_key.blank?

      # Si el texto ya no tiene palabras que parezcan nombres propios (todo es placeholder o común), saltar LLM
      return texto unless texto.match?(/\b[A-ZÁÉÍÓÚÑ][a-záéíóúñ]{2,}\b/)

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
      resultado = resultado.present? ? resultado.strip : texto

      limpiar_duplicados(resultado)
    rescue => e
      Rails.logger.error "[Annm::AnonimizadorGenerico] #{e.class}: #{e.message}"
      texto
    end

    private

    def limpiar_duplicados(texto)
      texto.gsub(/\[NOMBRE\](?:\s*\[NOMBRE\])+/, '[NOMBRE]')
           .gsub(/\[CARGO\](?:\s*\[CARGO\])+/, '[CARGO]')
           .gsub(/\[EMAIL\](?:\s*\[EMAIL\])+/, '[EMAIL]')
    end
  end
end