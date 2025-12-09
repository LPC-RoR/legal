module PdfGenerator
  class TarAprobacionService < BaseService
    # ✅ CAMBIA ESTO:
    # registrar TarAprobacion, self
    
    # ✅ A ESTO:
    PdfGenerator.registrar TarAprobacion, self

    def generar_y_guardar
      @registro = TarAprobacion.includes(:tar_calculos).find(@registro.id)
      
      html = renderizar_template('aprobacion', {
        tar_aprobacion: @registro,
        tar_calculos: @registro.tar_calculos,
        total_monto: @registro.tar_calculos.sum(:monto)
      })
      
      pdf = generar_pdf(html)
      guardar_en_act_archivo(pdf, 'aprobación')
      
      { success: true }
    rescue StandardError => e
      { success: false, error: e.message }
    end

    private

    def pdf_options
      {
        format: 'A4',
        margin: { top: '40px', right: '20px', bottom: '60px', left: '20px' }
      }
    end
  end
end