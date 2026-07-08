# app/models/clss_pdf_invstgcns.rb
class ClssPdfInvstgcns
  include ConditionalArray

  # UTILIZADO PARA DEFINIR QUÉ CÓDIGOS SE DESPLIEGAN
  DSPLY_CDGS = {
    dnnc: [
    ],
    dnncnt: [
      { code: 'txt_mdds_rsgrd', condition: ->(o) { true } },
      { code: 'txt_mdds_crrctvs_sncns', condition: ->(o) { true } },
    ],
    dnncd: [
      { code: 'txt_mdds_rsgrd', condition: ->(o) { true } },
      { code: 'txt_mdds_crrctvs_sncns', condition: ->(o) { true } },
    ]
  }

  def self.dsply_codes_for(ownr)
    available_codes_for(ownr, DSPLY_CDGS[ownr.kywrd[:sym]])
  end

  def self.nombre
    {
      'txt_mdds_rsgrd'          => 'Notificación de las medidas de resguardo',
      'txt_mdds_crrctvs_sncns'  => 'Notificación de las medidas correctivas y sanciones'
    }
  end

  class << self

    # ============================================
    # REPORTE: MEDIDAS CORRECTIVAS Y SANCIONES
    # ============================================
    # @param objeto_id [Integer] ID de TxtEditable
    # @param opciones [Hash] Debe incluir :participante (denunciante/denunciado)
    # @param ownr [Object] Ignorado, se usa el participante como ownr
    def datos_txt_mdds_crrctvs_sncns(objeto_id, opciones = {}, ownr: nil)
      txt_editable = TxtEditable.find(objeto_id)
      krn_denuncia = txt_editable.ownr
      
      raise "TxtEditable debe pertenecer a KrnDenuncia" unless krn_denuncia.is_a?(KrnDenuncia)
      
      participante = opciones[:participante]
      raise "Se requiere :participante en opciones" unless participante.present?
      
      # Determinar tipo de participante
      tipo_participante = case participante.class.name
                          when 'KrnDenunciante' then 'denunciante'
                          when 'KrnDenunciado'  then 'denunciado'
                          else 'participante'
                          end
      
      {
        txt_editable: txt_editable,
        contenido: txt_editable.contenido,  # ActionText
        krn_denuncia: krn_denuncia,
#        fecha_mdds_crrctvs_sncns: krn_denuncia&.plz_fecha_inicio(:etp_mdds_sncns),
        participante: participante,
        tipo_participante: tipo_participante,
        # ownr será el participante (lo establece el servicio)
        empresa: krn_denuncia.ownr,  # Para logo y footer
        denunciantes: krn_denuncia.krn_denunciantes,
        denunciados: krn_denuncia.krn_denunciados
      }
    end

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