# app/models/clss_pdf_invstgcns.rb
class ClssPdfInvstgcns
  include ConditionalArray

  OPTNL_CDGS    = ['crdncn_apt', 'txt_dnnc_annmzd', 'txt_dnnc_rsmn', 'drchs', 'antecedentes', 'dts_incmbnts', 'dts_tstgs', 
    'txt_dclrcn_annmzd', 'txt_dclrcn_rsmn', 'txt_mdfccn_mdds_rsgrd', 'antecedentes_annm']

  # UTILIZADO PARA DEFINIR QUÉ CÓDIGOS SE DESPLIEGAN
  DSPLY_CDGS    = {
    invstgdr: [
      { code: 'txt_invstgdr_dsgncn',    condition: ->(o) { true } },
      { code: 'invstgdr_titulo_prfsnl', condition: ->(o) { true } }
    ],
    dnnc: [
      { code: 'denuncia',           condition: ->(o) { o.via_declaracion != 'Presencial' || o.tipo_declaracion != 'Verbal' } },
      { code: 'txt_acta',           condition: ->(o) { o.via_declaracion == 'Presencial' && o.tipo_declaracion == 'Verbal' } },
      { code: 'crdncn_apt',         condition: ->(o) { !!o.ownr.coordinacion_apt && o.ownr.app_contactos.exists?(grupo: 'Apt') && o.krn_denunciantes.any? } },
      { code: 'dts_incmbnts',       condition: ->(o) { !!o.ownr.verificacion_datos && o.ownr.app_contactos.exists?(grupo: 'RRHH') && o.krn_denunciantes.any? } },
      { code: 'dts_tstgs',          condition: ->(o) { !!o.ownr.verificacion_datos && o.ownr.app_contactos.exists?(grupo: 'RRHH') && o.krn_testigos.any? } },
      { code: 'txt_dnnc_annmzd',    condition: ->(o) { o&.act_archivos&.with_attached_pdf&.where_code('denuncia')&.any? } },
      { code: 'txt_dnnc_rsmn',      condition: ->(o) { o&.act_archivos&.with_attached_pdf&.where_code('denuncia')&.any? } },
      { code: 'txt_dnnc_obsrvcns',  condition: ->(o) { o&.evlcn_dnnc == 'Con observaciones' } },
      { code: 'dnnc_crrgd',         condition: ->(o) { o&.evlcn_dnnc == 'Con observaciones' } },
      { code: 'txt_infrm',          condition: ->(o) { o&.dclrcns_completas? } }
    ],
    dnncnt: [
      { code: 'rprsntcn',               condition: ->(o) { o.dnnc.presentado_por == 'Representante' } },
      { code: 'artcl_516',              condition: ->(o) { !!o.articulo_516 } },
      { code: 'dnncnt_info_oblgtr',     condition: ->(o) { true } },
      { code: 'comprobante',            condition: ->(o) { true } },
      { code: 'apt',                    condition: ->(o) { true } },
      { code: 'invstgcn',               condition: ->(o) { true } },
      { code: 'drchs',                  condition: ->(o) { true } },
      { code: 'txt_mdds_rsgrd',         condition: ->(o) { true } },
      { code: 'txt_mdfccn_mdds_rsgrd',  condition: ->(o) { true } },
      { code: 'antecedentes',           condition: ->(o) { true } },
      { code: 'antecedentes_annm',      condition: ->(o) { true } },
      { code: 'invstgdr',               condition: ->(o) { o.dnnc.krn_inv_denuncias.any? } },
      { code: 'txt_mdds_crrctvs_sncns', condition: ->(o) { o.dnnc.todos_tienen_txt_mdds_sncns? } },
    ],
    dnncd: [
      { code: 'artcl_516',              condition: ->(o) { !!o.articulo_516 } },
      { code: 'invstgcn',               condition: ->(o) { true } },
      { code: 'drchs',                  condition: ->(o) { true } },
      { code: 'txt_mdds_rsgrd',         condition: ->(o) { true } },
      { code: 'txt_mdfccn_mdds_rsgrd',  condition: ->(o) { true } },
      { code: 'antecedentes',           condition: ->(o) { true } },
      { code: 'antecedentes_annm',      condition: ->(o) { true } },
      { code: 'invstgdr',               condition: ->(o) { o.dnnc.krn_inv_denuncias.any? } },
      { code: 'txt_mdds_crrctvs_sncns', condition: ->(o) { o.dnnc.todos_tienen_txt_mdds_sncns? } }
    ],
    tstg: [
#      { code: 'drchs',                  condition: ->(o) { true } },
      { code: 'antecedentes',           condition: ->(o) { true } },
      { code: 'antecedentes_annm',      condition: ->(o) { true } },
    ]
  }

  def self.dsply_codes_for(ownr)
    items = DSPLY_CDGS[ownr.kywrd[:sym]] || []
    available_codes_for(ownr, items)
  end

  def self.nombre
    {
      'txt_invstgdr_dsgncn'       => 'Designación del investigador (declaración)',
      'dsgncn_invstgdr'           => 'Designación del investigador',
      'expdnt_annmzd'             => 'Expediente anonimizado',    # Este funciona para combinados REVISAR
      'expdnt_annmzd_crtl'        => 'Carátula del expediente anonimizado',
      'expdnt_annmzd_pruebas'     => 'Sección medios de prueba del expediente anonimizado',
      'invstgdr_titulo_prfsnl'  => 'Título profesional del investigador',
      'rprsntcn'                => 'Poder simple que establece la representación',
      'artcl_516'               => 'Solicitud de aplicación del artículo 516',
      'crdncn_apt'              => 'Coordinación de Atención Psicológica Temprana',
      'dts_incmbnts'            => 'Verificación de datos de las personas denunciantes y denunciadas',
      'dts_tstgs'               => 'Verificación de datos de los testigos',
      'denuncia'                => 'Denuncia',
      'txt_dnnc_annmzd'         => 'Denuncia anonimizada',
      'txt_dnnc_rsmn'           => 'Resumen de la denuncia',
      'dnncnt_info_oblgtr'      => 'Información obligatoria para las personas denunciantes',
      'comprobante'             => 'Comprobante de recepción de denuncia',
      'invstgcn'                => 'Notificación de recepción de denuncia',
      'drchs'                   => 'Derechos y obligaciones de los participantes',
      'apt'                     => 'Evidencias de atención psicológica temprana',
      'txt_mdds_rsgrd'          => 'Notificación de las medidas de resguardo',
      'txt_mdfccn_mdds_rsgrd'   => 'Complementación o modificación de medidas de resguardo',
      'antecedentes'            => 'Documentos presentados por el participante',
      'antecedentes_annm'       => 'Antecedentes anonimizados manualmente',
      'invstgdr'                => 'Notificación del investigador asignado',
      'dclrcn'                    => 'Citación a declarar para el participante',
      'txt_dclrcn'                => 'Declaración para firmar',
      'declaracion'               => 'Declaración firmada',
      'txt_dclrcn_annmzd'         => 'Declaración anonimizada',
      'txt_dclrcn_rsmn'           => 'Hechos de la declaración',
      'txt_infrm'                 => 'Informe de investigación',
      'txt_mdds_crrctvs_sncns'    => 'Notificación de las medidas correctivas y sanciones',
      'txt_annm_declaraciones'    => 'Expediente anonimizado: declaraciones de los participantes',
      'txt_annm_medios_de_prueba' => 'Expediente anonimizado: medios de prueba'
    }
  end

  def self.optnl_code?(code)
    OPTNL_CDGS.include?(code)
  end

  # ---------------------- Control de despliegue
  # Se usa para el despliegue pero también para seleccionar en carga_pdf la opción mltpls si corresponde generar más de un PDF
  def self.has_one?(code)
    ['crdncn_apt', 'dts_prncpls', 'dts_tstgs', 'denuncia', 'dnnc_annmzd', 'dnnc_rsmn', 
      'dnncnt_info_oblgtr', 'comprobante', 'invstgcn', 'drchs',
      'txt_invstgdr_dsgncn', 'txt_dnnc_annmzd', 'txt_dnnc_rsmn', 
      'dclrcn', 'txt_dclrcn', 'txt_dclrcn_annmzd', 'txt_dclrcn_rsmn', 'declaracion',
      'txt_infrm', 'expdnt_annmzd_crtl', 'expdnt_annmzd_pruebas', 
      'txt_annm_medios_de_prueba', 'txt_annm_declaraciones'].include?(code)
  end

  def self.cntrl_fecha?(code)
    ['apt', 'txt_mdds_crrctvs_sncns'].include?(code)
  end

  def self.cntrl_fecha_hora?(code)
    [].include?(code)
  end

  def self.no_tmplt?(code)
    ['denuncia', 'dnnc_annmzd', 'dnnc_rsmn', 'apt', 'antecedentes', 'antecedentes_annm', 'invstgdr', 'invstgdr_titulo_prfsnl', 
      'dclrcn', 'declaracion'].include?(code)
  end

  def self.no_sndng_code?(code)
    ['txt_invstgdr_dsgncn', 'txt_annm_medios_de_prueba', 'txt_annm_declaraciones'].include?(code)
  end

  def self.ref_code?(code)
    ['txt_mdds_crrctvs_sncns', 'txt_mdds_rsgrd', 'txt_mdfccn_mdds_rsgrd', 'invstgdr', 'dclrcn'].include?(code)
  end

  def self.ref_clss(code)
    case code
    when 'txt_mdds_crrctvs_sncns', 'txt_mdfccn_mdds_rsgrd', 'txt_mdds_rsgrd'
      TxtEditable
    when 'invstgdr'
      KrnInvDenuncia
    when 'dclrcn'
      KrnDeclaracion
    end
  end

  # ---------------------- Control de despliegue (final)

  # Un reporte puede generar pdfs para múltiples ownr y no tener ref
  ### DEPRECATED
  def self.ownr_mltpls?(code)
    ['txt_mdds_crrctvs_sncns', 'txt_mdds_rsgrd', 'invstgcn'].include?(code)
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
      when 'invstgcn', 'drchs'
        ownr = opciones[:ownr]
        dnnc = ownr.dnnc
        {
          ownr: ownr,
          dnnc: dnnc,
          empresa: dnnc.ownr
        }
      when 'crdncn_apt', 'dts_prncpls', 'dts_tstgs'
        objeto = KrnDenuncia.find(objeto_id)
        grupo  = reporte.to_s == 'crdncn_apt' ? 'Apt' : 'RRHH'
        {
          objeto: objeto,
          ownr: opciones[:ownr] || objeto.ownr,
          contactos: objeto.ownr.app_contactos.where(grupo: grupo),
          grupo: grupo
        }
      when 'invstgdr'
        objeto = KrnInvDenuncia.find(objeto_id)    # ← el texto editable
        ownr   = opciones[:ownr]                   # ← el participante | dnnc
        {
          objeto: objeto,
          ownr: ownr,
          dnnc: ownr.dnnc,
          empresa: ownr.dnnc.ownr
        }
      when 'dclrcn'
        objeto = KrnDeclaracion.find(objeto_id)    # ← la declaración
        ownr   = objeto.ownr                        # ← el participante (forzado)
        {
          objeto: objeto,
          ownr: ownr,
          dnnc: ownr.dnnc,
          empresa: ownr.dnnc.ownr
        }
      when 'txt_mdds_rsgrd', 'txt_mdfccn_mdds_rsgrd', 'txt_mdds_crrctvs_sncns', 'txt_invstgdr_dsgncn', 'txt_annm_declaraciones'
        objeto = TxtEditable.find(objeto_id)    # ← el texto editable
        ownr   = opciones[:ownr]                # ← el participante | dnnc
        {
          objeto: objeto,
          ownr: ownr,
          dnnc: ownr.dnnc,
          empresa: ownr.dnnc.ownr
        }
      when 'txt_dnnc_annmzd', 'txt_dclrcn_annmzd', 'txt_dclrcn'
        objeto = TxtEditable.find(objeto_id)    # ← el texto editable
        ownr   = objeto.ownr                    # ← dnnc
        {
          objeto: objeto,
          ownr: ownr,
          dnnc: ownr.dnnc,
          empresa: ownr.dnnc.ownr
        }
      when 'expdnt_annmzd_crtl', 'expdnt_annmzd_pruebas', 'dnnc'
        objeto = KrnDenuncia.find(objeto_id)
        { objeto: objeto, ownr: objeto }
      when 'dnncnt_info_oblgtr', 'comprobante'
        objeto = KrnDenunciante.find(objeto_id)
        { objeto: objeto, 
          empresa: objeto.krn_denuncia.ownr,
          ownr: opciones[:ownr] || objeto.ownr }
      else
        raise "Reporte de investigaciones no soportado: #{reporte}"
      end
    end

    def participantes_para(denuncia, reporte)
      case reporte.to_s
      when 'dnncnt_info_oblgtr'
        denuncia.krn_denunciantes
      when 'dclrcn', 'txt_dclrcn', 'invstgdr'
        denuncia.krn_denunciantes + denuncia.krn_denunciados
      when 'crdncn_apt', 'dts_prncpls', 'dts_tstgs'
        denuncia.ownr.app_contactos.where(grupo: reporte == 'crdncn_apt' ? 'Apt' : 'RRHH')
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