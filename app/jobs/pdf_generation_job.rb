# Para la generación del PDF de Aprobacion

class PdfGenerationJob < ApplicationJob
  queue_as :pdf_generation
  
  def perform(modelo_nombre, registro_id, tipo = nil)
    modelo_clase = modelo_nombre.constantize
    registro = modelo_clase.find(registro_id)
    
    # ✅ CARGA POR CONVENCIÓN DIRECTA (garantizado)
    nombre_servicio = "#{modelo_nombre.demodulize}Service"
    servicio_path = "pdf_generator/#{modelo_nombre.underscore}_service"
    
    # Forzar carga
    require_dependency servicio_path
    
    # Obtener clase
    service_class = "PdfGenerator::#{nombre_servicio}".constantize
    
    # Ejecutar
    resultado = service_class.new(registro, tipo: tipo).generar_y_guardar
    
    if resultado[:success]
      Rails.logger.info "✅ PDF generado exitosamente"
    else
      Rails.logger.error "❌ PDF falló: #{resultado[:error]}"
    end
  rescue StandardError => e
    Rails.logger.error "💥 Error inesperado: #{e.message}"
    Rails.logger.error e.backtrace.first(5).join("\n")
    raise
  end
end