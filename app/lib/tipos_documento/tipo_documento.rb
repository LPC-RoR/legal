# app/services/tipos_documento/tipo_documento.rb
# app/services/tipos_documento/tipo_documento.rb
class TipoDocumento
  def initialize(service)
    @service = service
  end

  def procesar!
    raise NotImplementedError
  end

  private

  def chat(prompt)
    @service.send(:chat_with_retry, prompt)
  end

  def crear_act_texto(**attrs)
    @service.send(:crear_act_texto, **attrs)
  end

  def safe_json_parse(str)
    # Limpia formato ```json ... ``` y otros wrappers
    cleaned = str.to_s
                  .gsub(/```(?:json|JSON)?\s*/i, '')  # Elimina ```json
                  .gsub(/```\s*$/, '')                # Elimina cierre ```
                  .strip
    
    JSON.parse(cleaned)
  rescue JSON::ParserError => e
    Rails.logger.warn("[TipoDocumento] ❌ JSON parse failed: #{e.message}. String: #{cleaned[0..100]}...")
    { "demandantes" => [], "demandados" => [], "testigos" => [] }
  end
end