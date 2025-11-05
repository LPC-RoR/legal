# app/services/tipos_documento/tipo_documento.rb
class TipoDocumento
  def initialize(service)
    @service = service        # gives access to @act_archivo, chat_with_retry, crear_act_texto …
  end

  # entry point – returns true / false
  def procesar!
    raise NotImplementedError
  end

  private

  # helper that delegates to the service
  def chat(prompt)
    @service.send(:chat_with_retry, prompt)
  end

  def crear_act_texto(**attrs)
    @service.send(:crear_act_texto, **attrs)
  end
end