# app/models/clss_pltfrm.rb
class ClssPdfPltfrm
  class << self
    def datos_usuarios_registrados(objeto_id, opciones = {}, ownr: nil)
      {
        usuarios: Usuario.where(created_at: opciones[:rango] || 30.days.ago..Time.current).order(:created_at),
        ownr: ownr,  # Puede ser nil
        total: Usuario.count
      }
    end

    def datos_actividad_plataforma(objeto_id, opciones = {}, ownr: nil)
      rango = opciones[:rango] || 7.days.ago..Time.current
      
      {
        logins: Session.where(created_at: rango).count,
        acciones: ActivityLog.where(created_at: rango).count,
        ownr: ownr
      }
    end

    def assets_para(reporte)
      {
        logo: 'pltfrm/logo.png',
        css:  'pdfs/pltfrm/styles.css'
      }
    end
  end
end