# app/models/clss_pdf_srvcs.rb
class ClssPdfSrvcs
  class << self
    def datos_ordenes_trabajo(objeto_id, opciones = {}, ownr: nil)
      {
        ordenes: OrdenTrabajo.where(estado: opciones[:estados] || %w[abierta en_proceso]).includes(:cliente, :tecnico),
        ownr: ownr
      }
    end

    def assets_para(reporte)
      {
        logo: 'srvcs/logo.png',
        css:  'pdfs/srvcs/styles.css'
      }
    end
  end
end