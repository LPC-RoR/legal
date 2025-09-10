# Sólo una clase para manejar el procedimiento
# app/models/procedimiento.rb
class ClssPrcdmnt
  REGLAS = {
    dnnc: {
      archivos: [
        { nombre: 'denuncia',           si: ->(o) { o.via_declaracion == 'Presencial' and o.tipo_declaracion == 'Verbal' } },
        { nombre: 'acta',               si: ->(o) { o.via_declaracion != 'Presencial' or (o.via_declaracion == 'Presencial' and o.tipo_declaracion != 'Verbal') } },
        { nombre: 'medidas_resguardo',  si: ->(o) { true } },
        { nombre: 'notificacion',       si: ->(o) { o.rcp_dt? } },
        { nombre: 'certificado',        si: ->(o) { o.on_dt? and o.derivaciones? } },
        { nombre: 'dvlcn_slctd',        si: ->(o) { o.ownr.activa_devolucion } },
        { nombre: 'dvlcn_rslcn',        si: ->(o) { o.solicitud_denuncia } },
        { nombre: 'objecion_antcdnts',  si: ->(o) { o.investigadores? ? o.krn_inv_denuncias.first.objetado : false } },
        { nombre: 'objecion_rslcn',     si: ->(o) { o.antecedentes_objecion? } },
        { nombre: 'analisis',           si: ->(o) { o.evlcn_incnsstnt } },
        { nombre: 'denuncia_corregida', si: ->(o) { o.evlcn_incnsstnt } },
        { nombre: 'informe',            si: ->(o) { o.declaraciones_completas? } },
        { nombre: 'pronunciamiento',    si: ->(o) { o.fecha_prnncmnt? } },
        { nombre: 'medidas_sanciones',  si: ->(o) { o.fecha_env_infrm? or o.plz_prnncmnt_vncd? } }
      ],
      acciones: [
        { tipo: 'verificar_email',      si: ->(o) { true } }
      ]
    },
    dnncnt: {
      archivos: [
        { nombre: 'representacion',     si: ->(o) { o.dnnc.presentado_por == KrnDenuncia::TIPOS_DENUNCIANTE[1] } },
        { nombre: 'antecedentes',       si: ->(o) { true } },
        { nombre: 'solicitud_516',      si: ->(o) { o.articulo_516 } },
        { nombre: 'apt',                si: ->(o) { true } },
        { nombre: 'declaracion',        si: ->(o) { o.dnnc.investigadores? } },
      ],
      acciones: [
        { tipo: 'verificar_email',      si: ->(o) { true } },
        { tipo: 'dnncnt_info_oblgtr',   si: ->(o) { true } },
        { tipo: 'drchs',                si: ->(o) { true } },
        { tipo: 'drvcn',                si: ->(o) { true } },
        { tipo: 'invstgcn',             si: ->(o) { true } },
        { tipo: 'mdds_rsgrd',           si: ->(o) { true } },
        { tipo: 'invstgdr',             si: ->(o) { true } }
      ]
    },
    dnncd: {
      archivos: [
        { nombre: 'solicitud_516',      si: ->(o) { o.articulo_516 } },
        { nombre: 'antecedentes',       si: ->(o) { o.dnnc.investigadores? } },
        { nombre: 'declaracion',        si: ->(o) { o.dnnc.investigadores? } },
      ],
      acciones: [
        { tipo: 'verificar_email',      si: ->(o) { true } },
        { tipo: 'drchs',                si: ->(o) { true } },
        { tipo: 'drvcn',                si: ->(o) { true } },
        { tipo: 'invstgcn',             si: ->(o) { true } },
        { tipo: 'mdds_rsgrd',           si: ->(o) { true } },
        { tipo: 'invstgdr',             si: ->(o) { true } }
      ]
    },
    tstg: {
      archivos: [
        { nombre: 'solicitud_516',      si: ->(o) { o.articulo_516 } },
        { nombre: 'antecedentes',       si: ->(o) { o.dnnc.investigadores? } },
        { nombre: 'declaracion',        si: ->(o) { o.dnnc.investigadores? } },
      ],
      acciones: [
        { tipo: 'verificar_email',      si: ->(o) { true } },
        { tipo: 'drchs',                si: ->(o) { true } },
        { tipo: 'drvcn',                si: ->(o) { true } },
        { tipo: 'invstgcn',             si: ->(o) { true } },
        { tipo: 'mdds_rsgrd',           si: ->(o) { true } },
        { tipo: 'invstgdr',             si: ->(o) { true } }
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

  def self.act_nombre
    {
          'denuncia'            => 'Denuncia',
          'acta'                => 'Acta de denuncia firmada y timbrada',
          'medidas_resguardo'   => 'Medidas de resguardo',
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
          'apt'                 => 'Evidencia de atención psicológica temprana',
          'declaracion'         => 'Declaración del participante',
          'verificar_email'     => 'Verificación de la dirección de correo electrónico',
          'dnncnt_info_oblgtr'  => 'Información obligatoria para la persona participante',
          'drchs'               => 'Derechos y obligaciones de los participantes',
          'invstgcn'            => 'Notificación de recepción de denuncia ley 21.643',
          'drvcn'               => 'Notificación de la derivación de la denuncia',
          'mdds_rsgrd'          => 'Medidas de resguardo',
          'invstgdr'            => 'Notificación del investigador asignado a la denuncia',

    }
  end.freeze

  def self.act_optnl?(act)
    ['antecedentes'].include?(act)
  end

  def self.act_lst?(act)
    ['medidas_resguardo', 'objecion_antcdnts', 'medidas_sanciones', 'antecedentes', 'apt'].include?(act)
  end

  def self.act_fecha(act)
    ['medidas_resguardo', 'medidas_sanciones', 'antecedentes', 'apt'].include?(act)
  end

  def self.list_excluded?(act)
    ['verificar_email'].include?(act)
  end

  def self.ref_generated?(act)
    ['invstgdr', 'drvcn', 'mdds_rsgrd'].include?(act)
  end

  def self.actn_multpl?(act)
    ['invstgdr', 'drvcn', 'mdds_rsgrd'].include?(act)
  end
end