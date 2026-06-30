# app/models/clss_pdf_invstgcns.rb
class ClssPdfInvstgcns
  class << self
    def datos_para(reporte, objeto_id, opciones = {})
      case reporte.to_s
      when 'dnnc', 'st_dclrcns'
        objeto = KrnDenuncia.find(objeto_id)
        { objeto: objeto, ownr: opciones[:ownr] || objeto.ownr }
      when 'dclrcn', 'txt_dclrcn'
        objeto = KrnDeclaracion.find(objeto_id)
        { objeto: objeto, ownr: opciones[:ownr] || objeto.ownr }
      else
        raise "Reporte de investigaciones no soportado: #{reporte}"
      end
    end

    def participantes_para(denuncia, reporte)
      case reporte.to_s
      when 'dclrcn', 'txt_dclrcn'
        denuncia.krn_denunciantes + denuncia.krn_denunciados
      when 'crdncn_apt', 'infrmcn'
        AppContacto.where(grupo: reporte == 'crdncn_apt' ? 'Apt' : 'RRHH')
      else
        [denuncia]
      end
    end

    def assets_para(reporte)
      {
        logo: 'invstgcns/logo.png',
        css:  'pdfs/invstgcns/styles.css'
      }
    end
  end
end