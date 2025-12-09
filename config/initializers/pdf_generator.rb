# Define el módulo antes de cualquier clase
module PdfGenerator
  def self.registros
    @registros ||= {}
  end

  def self.registrar(modelo_clase, servicio_clase)
    Rails.logger.info "📝 REGISTRANDO: #{modelo_clase.name} => #{servicio_clase.name}"
    registros[modelo_clase.name] = servicio_clase
  end

  def self.servicio_para(modelo_clase)
    registros[modelo_clase.name] || BaseService
  end
end

# Forzar carga de BaseService primero
Rails.application.config.to_prepare do
  if defined?(require_dependency)
    require_dependency 'pdf_generator/base_service'
  end
  PdfGenerator.registros.clear
end