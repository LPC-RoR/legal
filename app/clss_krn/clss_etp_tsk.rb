class ClssEtpTsk < ApplicationRecord

  DNNCNT_CDGS   = ['rprsntcn', 'artcl_516', 'dnncnt_info_oblgtr', 'comprobante', 'apt'].freeze
  INCMBNTS_CDGS = ['invstgcn', 'drchs', 'txt_mdds_rsgrd', 'txt_mdds_crrctvs_sncns'].freeze
  PRTCPNTS_CDGS = ['antecedentes'].freeze

  INVSTGCN_CDGS = ['dts_tstgs', 'txt_dnnc_obsrvcns', 'dnnc_crrgd', 'txt_infrm']

  DCLRCN_CDGS   = ['dclrcn', 'txt_dclrcn', 'declaracion', 'txt_dclrcn_annmzd', 'txt_dclrcn_rsmn']
  RCRSS_CDGS    = ['txt_invstgdr_dsgncn', 'expdnt_annmzd_crtl', 'expdnt_annmzd_pruebas']

  def self.etp_nombre
    {
      etp_rcpcn:      'Tramites propios de la recepción',
      etp_invstgcn:   'Investigación de la denuncia',
      etp_infrm:      'Informe de investigación',
      etp_prnncmnt:   'Pronunciamiento de la Direccón del Trabajo',
      etp_mdds_sncns: 'Aplicación de las medidas correctivas y sanciones',
      etp_cerrada:    'Procedimiento cerrado'
    }
  end

  def self.etp_status
    {
      etp_rcpcn:      'Recepción',
      etp_invstgcn:   'Investigación',
      etp_infrm:      'Informe',
      etp_prnncmnt:   'Pronunciamiento DT',
      etp_mdds_sncns: 'Medidas & sanciones',
      etp_cerrada:    'Cerrada'
    }
  end

  def self.tsk_nombre
    {
      'tsk_ingrs'                   => 'Ingreso de datos de la denuncia',
      'tsk_dcmnts_cntrlds'          => 'Generar (o subir) & enviar los documentos controlados propios de la recepción de denuncias',
      'tsk_cierre_rcpcn'            => 'Registrar el cierre de la recepción',
      'tsk_frm_invstgcn'            => 'Asignación del investigador y evaluación de la denuncia',
      'tsk_dcmnts_cntrlds_invstgcn' => 'Documentos controlados de la investigación de la denuncia',
      'tsk_dclrcns'                 => 'Agendamiento y toma de las declaraciones',
      'tsk_redaccion_infrm'         => 'Redacción del informe de investigación',
      'tsk_cierre_invstgcn'         => 'Cierre de la investigación',
      'tsk_infrm'                   => 'Envio/Recepción de informe de investigación',
      'tsk_prnncmnt'                => 'Pronunciamiento de la Dirección del Trabajo',
      'tsk_mdds_sncns'              => 'Aplicación de medidas correctivas y sanciones',
      'tsk_prcdmnt_trmnd'           => 'Procedimiento terminado',
    }
  end

  def self.tsk_infrm_nombre(dnnc)
    dnnc.tramite_aviso_inicio.present? ? 'Depósito de la denuncia en la plataforma de la DT' : 'Recepción de la denuncia investigada por la DT'
  end

  # *************************************************
  # SEÑALIZADORES del TAB
  # *************************************************
  def self.frm_tsks
    ['tsk_cierre_rcpcn', 'tsk_frm_invstgcn', 'tsk_prnncmnt'].freeze
  end

  def self.dnnc_tsks
    ['tsk_ingrs', 'tsk_cierre_rcpcn', 'tsk_frm_invstgcn', 'tsk_dclrcns'].freeze
  end

  def self.ntfccns_tsks
    ['tsk_dcmnts_cntrlds']
  end

  def self.dclrcns_tsks
    ['tsk_dclrcns']
  end

  # *************************************************
  # ARCHIVOS CONTROLADOS POR ETAPA
  # *************************************************
  def self.archivos_controlados_rcpcn_completos?(denuncia)
    ownrs = [
      *denuncia.krn_denunciantes,
      *denuncia.krn_denunciados,
      *denuncia.krn_testigos
    ]

    # Códigos obligatorios: los de los tres grupos menos los opcionales
    codigos_obligatorios = (DNNCNT_CDGS + INCMBNTS_CDGS + PRTCPNTS_CDGS) - ClssPdfInvstgcns::OPTNL_CDGS

    ownrs.all? do |ownr|
      codigos_a_verificar = ClssPdfInvstgcns.dsply_codes_for(ownr) & codigos_obligatorios

      codigos_a_verificar.all? do |code|
        ownr.act_archivos.exists?(act_archivo: code)
      end
    end
  end

  def self.archivos_controlados_invstgcn_completos?(denuncia)
    # Códigos obligatorios: los de los tres grupos menos los opcionales
    codigos_obligatorios = INVSTGCN_CDGS - ClssPdfInvstgcns::OPTNL_CDGS
    codigos_a_verificar = ClssPdfInvstgcns.dsply_codes_for(denuncia) & codigos_obligatorios
    if codigos_a_verificar.empty?
      true
    else
      codigos_a_verificar.all? do |code|
        denuncia.act_archivos.exists?(act_archivo: code)
      end
    end
  end

end