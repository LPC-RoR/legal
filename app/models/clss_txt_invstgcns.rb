# app/models/clss_pdf_invstgcns.rb
class ClssTxtInvstgcns
  include ConditionalArray

  # Definición estática de códigos con condiciones
  CDGS = {
    dnnc: [
      { code: 'txt_mdds_rsgrd', condition: ->(o) { true } },
      { code: 'txt_mdds_crrctvs_sncns', condition: ->(o) { true } },
    ],
    dnncnt: [
    ],
    dnncd: [
    ],
    emprs: [
      { code: 'firma_mdds', condition: ->(o) { true } },
    ]
  }

  def self.txt_name
    {
      'txt_mdds_rsgrd'          => 'Medidas de resguardo',
      'txt_mdds_crrctvs_sncns'  => 'Medidas correctivas y sanciones',
      'firma_mdds'              => 'Firma para notificación de medidas'
    }
  end

  def self.codes_for(ownr)
    available_codes_for(ownr, CDGS[ownr.kywrd[:sym]])
  end

  def self.rdrccn_path(txt_objt)
    case txt_objt.ownr.class.name
    when 'Empresa'
      "/empresas/#{txt_objt.ownr.id}/edit"
    else
      txt_objt.ownr.dnnc
    end
  end

  class << self


    # DEPRECATED
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