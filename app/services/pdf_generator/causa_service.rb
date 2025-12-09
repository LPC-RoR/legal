# EJEMPLO de un EVENTUAL reporte generado desde un objeto de Causa

module PdfGenerator
  class CausaService < BaseService
    # ✅ CAMBIA ESTO:
    # registrar Causa, self
    
    # ✅ A ESTO:
    PdfGenerator.registrar Causa, self

    def generar_y_guardar
      @registro = Causa.includes(:tareas, :documentos).find(@registro.id)
      
      html = renderizar_template('causa', {
        causa: @registro,
        tareas: @registro.tareas,
        documentos: @registro.documentos
      })
      
      pdf = generar_pdf(html, format: 'Letter')
      guardar_en_act_archivo(pdf, 'reporte_causa')
      
      { success: true }
    rescue StandardError => e
      Rails.logger.error "PDF Causa ##{@registro.id}: #{e.message}"
      { success: false, error: e.message }
    end
  end
end