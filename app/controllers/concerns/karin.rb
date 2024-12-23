module Karin
  extend ActiveSupport::Concern

  # --------------------------------------------------------------------------------------------- GENERAL

  #Control de despliegue de Archivos

  def krn_cntrl(ownr)
    dnnc = ownr.class.name == 'KrnDenuncia' ? ownr : (dnnc = ownr.class.name == 'KrnTestigo' ? ownr.ownr.krn_denuncia : ownr.krn_denuncia)
    {
       # GESTIÓN INICIAL DE LA DENUNCIA
      'dnnc_denuncia' => dnnc.tipo_declaracion != 'Verbal',     # Denuncia se presenta por escrito
      'dnnc_acta' => dnnc.tipo_declaracion == 'Verbal',         # Denuncia se presenta en forma verbal
      'dnnc_notificacion' => dnnc.rcp_dt?,                      # Denuncia derivada a la DT o recibida por ella
      'dnncnt_rprsntcn' => dnnc.rprsntnt?,                      # Denuncia presentada por un representante

      'dnnc_certificado' => dnnc.drv_dt? == true,               # DT certifica que recibió la denuncia que le derivamos

      'dnncnt_diat_diep' => true,
      'mdds_rsgrd' => true,

      'antcdnts_objcn' => dnnc.dnnc_objcn_invstgdr?,
      'rslcn_objcn' => dnnc.dnnc_objcn_invstgdr?,

      'dnnc_evlcn' => (dnnc.vlr_dnnc_eval_ok? and dnnc.dnnc_eval_ok? == false),
      'dnnc_corrgd' => (dnnc.vlr_dnnc_eval_ok? and dnnc.dnnc_eval_ok? == false),            # Denuncia corregida

      'prtcpnts_dclrcn' => true,                                        # Declaración
      'prtcpnts_antcdnts' => true,                                      # Antecedentes

      'infrm_invstgcn' => true,                                         # Informe de investigación
      'mdds_crrctvs' => true,
      'sncns' => true,

      'prnncmnt_dt' => true,
      'dnnc_mdds_sncns' => true,
    }
  end

  # --------------------------------------------------------------------------------------------- DNNC_JOT (JUST ONE TIME)
  def jot_cds
    [
      'rcp_externa',              # Denuncia recibida por una empresa externa
      'p_plus',                   # Producto extendido
      'emprs_extrn_prsnt',        # Empresa externa presente
      'prsncl',                   # Denuncia entregada presencialmente
      'rprsntnt',                 # Denuncia presentada por un representante
      'dt_obligatoria',           # Denuncia se debe derivar obligatoriamente a la DT
      'drvcn_rcbd',               # Denuncia que fue recibida por derivación
      'drvcns_any',               # Denuncia con derivaciones
      'vlr_drv_inf_dnncnt',       # Iforma al denunciante de sus opciones de investigación.
      'vlr_drv_dnncnt_optn',      # Opción del denunciante
      'frst_invstgdr',            # Denuncia con investigadores
      'vlr_dnnc_objcn_invstgdr',  # Campo de objeción del investigador presente
      'dnnc_objcn_invstgdr',      # Objeción del investigador
      'vlr_dnnc_rslcn_objcn',     # Campo resolucion presente
      'dnnc_rslcn_objcn',         # Resolución de la objeción
      'vlr_dnnc_eval_ok',         # Campo evaluación de denuncia
      'dnnc_eval_ok',             # Evaluación de la denuncia
      # TarControl
      'ingrs_dnnc_bsc',           # Ingreso de campos básicos de la denuncia
      'ingrs_nts_ds',             # Denunciantes ok e denunciados con información mínima
      'on_empresa',               # Denuncia en la empresa
      'vlr_sgmnt_emprs_extrn',    # Seguimiento de empresa externa
      'drv_dt',                   # Denuncia derivada a la DT
      'ingrs_fls_ok',             # Ingreso de archivos ok
      'prtcpnts_ok',              # Participantes OK
      'invstgdr_ok',              # Investigador OK
      'dclrcns_any',              # Alguna declaració,
      'dclrcns_ok',               # Declaraciones OK
      'envio_ok',                 # Informa a la DT, Certificado de recepción o Notificación de recepción de denuncia
      'on_dt',                    # Denuncia en la DT
      'dnncnts_any',              # Algún denunciante
      'tipo_declaracion_prsnt',   # Tipo de declaracion presente
      'representante_prsnt',      # Representante presente
      'drv_emprs_optn',           # Empresa opta por investigación en la empresa
      'fl_mdds_rsgrd',            # Hay algún archivo de Medidas de Resguardo
      'fecha_hora_dt_prsnt',      # Fecha hora DT presente
      'fecha_trmtcn_prsnt',       # Fecha de tramitación presente
      'fecha_ntfccn_prsnt',       # Fecha de notificación presente
      'fecha_ntfccn_invstgdr_prsnt', # Fecha de notificación de Investigador presente
      'scnd_invstgdr',            # Segundo investigador
      'fecha_hora_corregida_prsnt', # Fecha hora corregida presente
      'vlr_dnnc_crr_dclrcns',     # Cierre de declaraciones
      'vlr_dnnc_infrm_dt',        # Informe a la DT
      'fecha_trmn_prsnt',         # Fecha de tramitación presente
      'fecha_env_infrm_prsnt',    # Fecha envío informe
      'fecha_prnncmnt_prsnt',     # Fecha pronunciamiento presente
      'fecha_prcsd_prsnt',        # Fecha ...
      'dnncnts_rgstrs_ok',        # Registros de denunciantes OK
      'diat_diep_ok',             # DIAT/DIEP subido
      'no_vlnc',                  # Denuncia no es de violencia
      'dnncds_any',               # Algún denunciado
      'dnncds_rgstrs_ok',         # Denunciantes registros OK 
      'vlr_drv_emprs_optn',
    ]
  end

  def prtcpnts_cds
    [
      'emprs_extrn_prsnt',        # Empresa externa presente
      'drccn_ntfccn_prsnt',       # Dirección de notificación presente
      'vlr_dnnc_eval_ok',
      'dnnc_eval_ok',
      'on_empresa'
    ]
  end

  def get_dnnc_jot(ownr)
    lst = ownr.class.name == 'KrnDenuncia' ? jot_cds : prtcpnts_cds
    @dnnc_jot = {}
    lst.each do |jcod|
      @dnnc_jot[jcod] = ownr.send(jcod + '?')
    end
  end


  # --------------------------------------------------------------------------------------------- DENUNCIAS

  def krn_dnnc_dc_init(denuncia)
    @krn_cntrl = krn_cntrl(@objeto)
  end

  # --------------------------------------------------------------------------------------------- DERIVACIÓN

  def drvcn_mtv
    {
      'rcptn' => 'Recepción derivación de denuncia.',
      'extrn_dt' => 'Rerivación a la DT desde empresa externa.',
      'riohs' => 'RIOHS con protocolo no ha entrado en vigencia.',
      'a41' => 'Aplica artículo 4 inciso primero del Código del trabajo.',
      'seg' => 'Seguimiento de denuncia de empresa externa.',
      'd_optn' => 'Por determinación del denunciante',
      'e_optn' => 'Por determinación de la empresa'
    }
  end


end