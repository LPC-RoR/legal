# app/services/annm/anonimizador_llm.rb
module Annm
  class AnonimizadorLlm
    def initialize(api_key = nil)
      @api_key = api_key || Rails.application.credentials.openai_api_key
    end

    def anonimizar(texto, codigos, max_tokens: 4000)
      return texto if codigos.empty? || @api_key.blank?

      instrucciones = construir_instrucciones(codigos)
      return texto if instrucciones.empty?

      prompt = construir_prompt(texto, instrucciones)

      cliente = OpenAI::Client.new(access_token: @api_key)

      respuesta = cliente.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [{ role: "user", content: prompt }],
          temperature: 0.0,
          max_tokens: max_tokens
        }
      )

      texto_anon = respuesta.dig("choices", 0, "message", "content")
      texto_anon.present? ? texto_anon.strip : texto
    rescue => e
      Rails.logger.error "[Annm::AnonimizadorLlm] Error: #{e.message}"
      texto
    end

    private

    def construir_instrucciones(codigos)
      codigos.filter_map do |valor, metadata|
        tipo   = metadata["tipo"]   || metadata[:tipo]
        codigo = metadata["codigo"] || metadata[:codigo]
        next if valor.blank? || tipo.blank? || codigo.blank?

        "#{tipo.upcase}|#{valor}|#{codigo}"
      end
    end

    def construir_prompt(texto, instrucciones)
      <<~PROMPT
        Reemplaza estos datos en el texto por los códigos:

        FORMATO: TIPO|valor|CÓDIGO
        #{instrucciones.join("\n")}

        TEXTO:
        #{texto[0..2500]}

        REGLAS:
        1. Reemplaza nombres completos, parciales o placeholders tipo "Denunciante Pérez"
        2. Reemplaza RUTs en cualquier formato con/sin puntos
        3. Devuelve SOLO el texto con códigos, sin explicaciones
      PROMPT
    end
  end
end