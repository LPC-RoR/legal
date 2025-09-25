# Sólo una clase para manejar el procedimiento
# app/models/procedimiento.rb
class ClssPrcdmnt

  REGLAS = {
    dnnc: {
      archivos: [
        { nombre: 'denuncia',           si: ->(o) { o.via_declaracion != 'Presencial' or (o.via_declaracion == 'Presencial' and o.tipo_declaracion != 'Verbal') } },
        { nombre: 'acta',               si: ->(o) { o.via_declaracion == 'Presencial' and o.tipo_declaracion == 'Verbal' } },
        { nombre: 'mdds_rsgrd',         si: ->(o) { true } },
        { nombre: 'notificacion',       si: ->(o) { o.rcp_dt? } },
        { nombre: 'certificado',        si: ->(o) { o.on_dt? and o.krn_derivaciones.any? } },
        { nombre: 'dvlcn_slctd',        si: ->(o) { o.ownr.activa_devolucion } },
        { nombre: 'dvlcn_rslcn',        si: ->(o) { o.solicitud_denuncia } },
        { nombre: 'objecion_antcdnts',  si: ->(o) { o.krn_inv_denuncias.any? ? o.krn_inv_denuncias.first.objetado : false } },
        { nombre: 'objecion_rslcn',     si: ->(o) { o.antecedentes_objecion? } },
        { nombre: 'analisis',           si: ->(o) { o.evlcn_incnsstnt } },
        { nombre: 'denuncia_corregida', si: ->(o) { o.evlcn_incnsstnt } },
        { nombre: 'informe',            si: ->(o) { o.declaraciones_completas? } },
        { nombre: 'pronunciamiento',    si: ->(o) { o.fecha_prnncmnt? } },
        { nombre: 'medidas_sanciones',  si: ->(o) { o.fecha_env_infrm? or o.plz_prnncmnt_vncd? } }
      ],
      acciones: [
      ]
    },
    dnncnt: {
      archivos: [
        { nombre: 'representacion',     si: ->(o) { o.dnnc.presentado_por == KrnDenuncia::TIPOS_DENUNCIANTE[1] } },
        { nombre: 'antecedentes',       si: ->(o) { true } },
        { nombre: 'solicitud_516',      si: ->(o) { o.articulo_516 } },
        { nombre: 'comprobante_firmado',si: ->(o) { true } },
        { nombre: 'apt',                si: ->(o) { true } },
        { nombre: 'declaracion',        si: ->(o) { o.dnnc.krn_inv_denuncias.any? } },
      ],
      acciones: [
        { tipo: 'verificar_email',      si: ->(o) { true } },
        { tipo: 'dnncnt_info_oblgtr',   si: ->(o) { o.dnnc.rcp_empresa? or (o.dnnc.rcp_externa? and o.dnnc.empresa?) } },
        { tipo: 'comprobante',          si: ->(o) { o.dnnc.rcp_empresa? } },
        { tipo: 'drchs',                si: ->(o) { true } },
        { tipo: 'medidas_resguardo',    si: ->(o) { o.dnnc.tiene_mdds_rsgrd? } },
        { tipo: 'invstgcn',             si: ->(o) { true } },
        { tipo: 'drvcn',                si: ->(o) { o.dnnc.krn_derivaciones.any? } },
        { tipo: 'invstgdr',             si: ->(o) { o.dnnc.tiene_investigador? } }
      ]
    },
    dnncd: {
      archivos: [
        { nombre: 'solicitud_516',      si: ->(o) { o.articulo_516 } },
        { nombre: 'antecedentes',       si: ->(o) { o.dnnc.krn_inv_denuncias.any? } },
        { nombre: 'declaracion',        si: ->(o) { o.dnnc.krn_inv_denuncias.any? } },
      ],
      acciones: [
        { tipo: 'verificar_email',      si: ->(o) { true } },
        { tipo: 'drchs',                si: ->(o) { true } },
        { tipo: 'medidas_resguardo',    si: ->(o) { o.dnnc.tiene_mdds_rsgrd? } },
        { tipo: 'invstgcn',             si: ->(o) { true } },
        { tipo: 'drvcn',                si: ->(o) { o.dnnc.krn_derivaciones.any? } },
        { tipo: 'invstgdr',             si: ->(o) { o.dnnc.tiene_investigador? } }
      ]
    },
    tstg: {
      archivos: [
        { nombre: 'solicitud_516',      si: ->(o) { o.articulo_516 } },
        { nombre: 'antecedentes',       si: ->(o) { o.dnnc.krn_inv_denuncias.any? } },
        { nombre: 'declaracion',        si: ->(o) { o.dnnc.krn_inv_denuncias.any? } },
      ],
      acciones: [
        { tipo: 'verificar_email',      si: ->(o) { true } },
        { tipo: 'drchs',                si: ->(o) { true } },
        { tipo: 'invstgcn',             si: ->(o) { true } },
        { tipo: 'drvcn',                si: ->(o) { o.dnnc.krn_derivaciones.any? } },
        { tipo: 'invstgdr',             si: ->(o) { o.dnnc.tiene_investigador? } }
      ]
    }
  }.freeze

  def self.archivos_que_aplican(objt)
    REGLAS[objt.sym][:archivos].select { |r| r[:si].call(objt) }
                                     .map { |r| r[:nombre] }
  end

  def self.acciones_que_aplican(objt)
    REGLAS[objt.sym][:acciones].select { |r| r[:si].call(objt) }
                                     .map { |r| r[:tipo] }
  end

  def self.archivos_obligatorios(obj)
    archivos_que_aplican(obj).reject { |n| act_optnl?(n) }
  end

  def self.acciones_obligatorias(obj)
    acciones_que_aplican(obj).reject { |t| act_optnl?(t) }
  end

  def self.tsk_name
    {
      'dnncnt_info_oblgtr'    => 'tsk_dnncnt_info_oblgtr',
      'comprobante'           => 'tsk_comprobantes_firmados'
    }.freeze
  end

  def self.act_nombre
    {
          'etp_rcpcn'                 => 'Recepción de la denuncia',
          'etp_invstgcn'              => 'Investigación de la denuncia',
          'etp_infrm'                 => 'Informe de investigación',
          'etp_prnncmnt'              => 'Pronunciamiento de la Dirección del Trabajo',
          'etp_mdds_sncns'            => 'Medidas correctivas y sanciones',
          'etp_prcdmnt_cerrado'       => 'Procedimiento cerrado',
          'tsk_ingrs'                 => 'Ingreso de datos',
          'tsk_extrn_drvcn_emprs'     => 'Denuncia de la empresa recibida en empresa externa',
          'tsk_emprs_drvcn_extrn'     => 'Denuncia de empresa externa recibida en la empresa',
          'tsk_dnncnt_info_oblgtr'    => 'Entrega de información obligatoria a la persona denunciante',
          'tsk_dnncnt_optn_drvcn'     => 'Preguntar opción de derivación a la persona denunciante',
          'tsk_crdncn_apt'            => 'Coordinación de la atención psicológica temprana.',
          'tsk_comprobantes_firmados' => 'Subir comprobante(s) de denuncia firmado(s).',
          'tsk_notificar_dnnc'        => 'Notificar a los participantes el inicio de la investigación.',
          'tsk_mdds_rsgrd'            => 'Notificar medidas de resguardo',
          'tsk_evidencia_apt'         => 'Subir evidencia de la atención psicológica temprana',
          'tsk_emprs_optn_drvcn'      => 'La empresa determina su opción de derivación',
          'tsk_cierre_rcpcn'          => 'Registrar el cierre de la recepción',
          'tsk_asigna_invstgdr'       => 'Asigna investigador a la denuncia',
          'tsk_analisis_dnnc'         => 'Análisis de la denuncia',
          'tsk_dclrcns'               => 'Agendamiento y toma de declaraciones',
          'tsk_redaccion_infrm'       => 'Redacción del informe de investigación',
          'tsk_cierre_invstgcn'       => 'Cierre de la investigación',
          'tsk_infrm'                 => 'Envio/Recepción de informe de investigación',
          'tsk_prnncmnt'              => 'Pronunciamiento de la Dirección del Trabajo',
          'tsk_mdds_sncns'            => 'Aplicación de medidas correctivas y sanciones',
          'tsk_prcdmnt_trmnd'         => 'Procedimiento terminado',
          'denuncia'              => 'Denuncia',
          'acta'                  => 'Acta de denuncia firmada y timbrada',
          'comprobante_firmado'       => 'Comprobante de recepción de denuncia firmado',
          'mdds_rsgrd'                => 'Medidas de resguardo',
          'notificacion'        => 'Notificación de denuncia presentada en la Dirección del Trabajo',
          'certificado'         => 'Certificado de denuncia derivada a la Dirección del Trabajo',
          'dvlcn_slctd'         => 'Solicitud de devolución de denuncia',
          'dvlcn_rslcn'         => 'Resolución de la solicitud de devolución',
          'objecion_antcdnts'   => 'Antecedentes de la objeción al investigador',
          'objecion_rslcn'      => 'Resolución de la objeción al investigador',
          'analisis'            => 'Análisis de la denuncia',
          'denuncia_corregida'  => 'Denuncia corregida',
          'informe'             => 'Informe de investigación',
          'pronunciamiento'     => 'Pronunciamiento de la Dirección del Trabajo',
          'medidas_sanciones'   => 'Evidencia de la aplicación de medidas correctivas y sanciones',
          'representacion'      => 'Documento que respalda representación del denunciante',
          'antecedentes'        => 'Documentos presentados por el participante',
          'solicitud_516'       => 'Solicitud de aplicación artículo 516',
          'apt'                       => 'Evidencia de atención psicológica temprana',
          'declaracion'         => 'Declaración del participante',
          'verificar_email'           => 'Verificación de la dirección de correo electrónico',
          'dnncnt_info_oblgtr'        => 'Información obligatoria para la persona participante',
          'comprobante'               => 'Comprobante de recepción de denuncia',
          'drchs'               => 'Derechos y obligaciones de los participantes',
          'medidas_resguardo'         => 'Notificación de las medidas de resguardo',
          'invstgcn'                  => 'Notificación de recepción de denuncia ley 21.643',
          'drvcn'               => 'Notificación de la derivación de la denuncia',
          'invstgdr'            => 'Notificación del investigador asignado a la denuncia',
          'infrmcn'             => 'Verificación de datos de los participantes',
          'crdncn_apt'          => 'Coordinación de atención psocológica temprana',
          'dnnc'                      => 'Reporte del estado de la denuncia'

    }
  end.freeze

  def self.act_optnl?(act)
    ['antecedentes'].include?(act)
  end

  def self.act_lst?(act)
    ['mdds_rsgrd', 'medidas_resguardo', 'objecion_antcdnts', 'medidas_sanciones', 'antecedentes', 'apt'].include?(act)
  end

  def self.act_fecha(act)
    ['mdds_rsgrd', 'medidas_sanciones', 'antecedentes', 'apt'].include?(act)
  end

  def self.list_excluded?(act)
    ['verificar_email'].include?(act)
  end

  def self.ref_generated?(act)
    ['invstgdr', 'drvcn'].include?(act)
  end

  def self.actn_multpl?(act)
    ['invstgdr', 'drvcn', 'mdds_rsgrd', 'medidas_resguardo'].include?(act)
  end

  def self.plz_dsply(etp_sym, dnnc)
    if etp_sym == :etp_prnncmnt
      dnnc.not_on_dt? and dnnc.fecha_env_infrm?
    else
      dnnc.plz_fecha_cmplmnt(etp_sym)
    end 
  end
end