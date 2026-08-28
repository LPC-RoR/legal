class ClssEtpTsk < ApplicationRecord

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

  # *************************************************
  # SEÑALIZADORES del TAB
  # *************************************************
  def self.dnnc_tsks
    ['tsk_ingrs'].freeze
  end

  def self.ntfccns_tsks
    ['tsk_dcmnts_cntrlds']
  end

end