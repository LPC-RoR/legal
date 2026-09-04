# app/services/annm/anonimizador_generico.rb
module Annm
  class AnonimizadorGenerico
    def initialize(resumen_participantes: {}, api_key: nil)
      @resumen = resumen_participantes
      @api_key = api_key || Rails.application.credentials.openai_api_key
    end

    def anonimizar(texto)
      return texto if texto.blank? || @api_key.blank?

      # Si no quedan nombres propios sueltos, saltar LLM
      return texto unless texto.match?(/\b[A-ZÁÉÍÓÚÑ][a-záéíóúñ]{2,}\b/)

      prompt = construir_prompt(texto)

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

    def construir_prompt(texto)
      texto_truncado = texto.length > 12_000 ? texto[0..12_000] + "\n[...]" : texto

      if @resumen.any?
        instrucciones = @resumen.map do |abrev, datos|
          <<~LINEA
            - #{abrev}: nombre="#{datos[:nombre]}", cargo="#{datos[:cargo]}", email="#{datos[:email]}", rut="#{datos[:rut]}"
              → Reemplazar por: [#{abrev}] (nombre), [CARGO-#{abrev}] (cargo), [EMAIL-#{abrev}] (email), [CI-#{abrev}] (rut)
          LINEA
        end.join

        <<~PROMPT
          Eres un sistema forense de anonimización.

          PARTICIPANTES DEL PROCEDIMIENTO:
          #{instrucciones}

          REGLAS:
          1. Si encuentras datos de alguno de los participantes arriba, reemplázalos por su código correspondiente.
          2. Si encuentras una persona que NO está en la lista, reemplázala por [NOMBRE].
          3. Cargos genéricos → [CARGO]. Emails genéricos → [EMAIL]. RUTs genéricos → [CI|RUT]. Profesiones → [PROFESION].
          4. NO modifiques texto entre corchetes [...].
          5. Devuelve SOLO el texto anonimizado, sin explicaciones.

          TEXTO:
          #{texto_truncado}
        PROMPT
      else
        <<~PROMPT
          Anonimiza el siguiente texto:
          - Nombres de personas → [NOMBRE]
          - Cargos laborales → [CARGO]
          - Emails → [EMAIL]
          - RUTs chilenos → [CI|RUT]
          - Profesiones → [PROFESION]
          - NO modifiques texto entre corchetes [...]

          TEXTO:
          #{texto_truncado}
        PROMPT
      end
    end

    def limpiar_duplicados(texto)
      texto.gsub(/\[NOMBRE\](?:\s*\[NOMBRE\])+/, '[NOMBRE]')
           .gsub(/\[CARGO\](?:\s*\[CARGO\])+/, '[CARGO]')
           .gsub(/\[EMAIL\](?:\s*\[EMAIL\])+/, '[EMAIL]')
    end
  end
end