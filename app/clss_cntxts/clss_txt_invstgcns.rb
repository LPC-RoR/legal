# app/models/clss_pdf_invstgcns.rb
class ClssTxtInvstgcns
  include ConditionalArray

  DCLRCN_CDGS = ['txt_dclrcn', 'txt_dclrcn_annmzd']

  # Definición estática de códigos con condiciones
  CDGS = {
    emprs: [
      { code: 'txt_firma_cnl_dnncs',    condition: ->(o) { true } },
      { code: 'txt_firma_mdds',         condition: ->(o) { true } }
    ],
    invstgdr: [
      { code: 'txt_invstgdr_firma',     condition: ->(o) { true } },
      { code: 'txt_invstgdr_dsgncn',    condition: ->(o) { true } },
    ],
    dnnc: [
      { code: 'txt_mdds_rsgrd',         condition: ->(o) { true } },
      { code: 'txt_mdds_crrctvs_sncns', condition: ->(o) { true } },
      { code: 'txt_dnnc_annmzd',        condition: ->(o) { true } },
    ],
    dnncnt: [
      { code: 'txt_acta',               condition: ->(o) { o.dnnc.via_declaracion == 'Presencial' && o.dnnc.tipo_declaracion == 'Verbal' } },
    ],
    dnncd: [
    ],
    tstg: [
    ]
  }

  def self.nombre
    {
      'txt_firma_cnl_dnncs'     => 'Firma del canal de denuncias',
      'txt_firma_mdds'          => 'Firma para notificación de medidas',
      'txt_mdds_rsgrd'          => 'Medidas de resguardo',
      'txt_acta'                => 'Acta de la denuncia',
      'txt_mdds_crrctvs_sncns'  => 'Medidas correctivas y sanciones',
      'txt_dclrcn'              => 'Declaración del participante',
      'txt_invstgdr_firma'      => 'Firma del investigador',
      'txt_invstgdr_dsgncn'     => 'Designación del investigador',
      'txt_dnnc_annmzd'         => 'Denuncia anonimizada',
      'txt_dclrcn_annmzd'       => 'Declaración anonimizada',
    }
  end

  def self.dsply_codes_for(ownr)
    items = CDGS[ownr.kywrd[:sym]] || []
    available_codes_for(ownr, items)
  end

  # ---------------------- Control de despliegue
  def self.has_one?(code)
    ['firma_mdds'].include?(code)
  end

  def self.txt_no_tmplt?(code)
    ['txt_firma_cnl_dnncs', 'txt_firma_mdds', 'txt_invstgdr_firma', 'txt_invstgdr_dsgncn'].include?(code)
  end
  # ---------------------- Control de despliegue (final)



  def self.rdrccn_path(txt_objt)
    case txt_objt.ownr.class.name
    when 'Empresa'
      "/empresas/#{txt_objt.ownr.id}/edit"
    when 'KrnInvestigador'
      txt_objt.ownr
    else
      txt_objt.ownr.dnnc
    end
  end

  class << self

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