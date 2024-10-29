module Karin
  extend ActiveSupport::Concern

  # --------------------------------------------------------------------------------------------- GENERAL

  #Control de despliegue de Archivos

  def krn_cntrl(denuncia)
    {
      'dnnc_denuncia' => denuncia.tipo_declaracion != 'Verbal',     # Denuncia se presenta por escrito
      'dnnc_notificacion' => denuncia.rcp_dt?,                      # Denuncia derivada a la DT o recibida por ella
      'dnnc_acta' => denuncia.tipo_declaracion == 'Verbal',         # Denuncia se presenta en forma verbal
      'dnncnt_rprsntcn' => denuncia.rprsntnt?,                  # Denuncia presentada por un representante
      'dnncnt_diat_diep' => true,
      'mdds_rsgrd' => true,
      'dnnc_certificado' => denuncia.drv_dt? == true,               # DT certifica que recibió la denuncia que le derivamos
      'antcdnts_objcn' => denuncia.objcn_invstgdr?,
      'rslcn_objcn' => denuncia.objcn_invstgdr?,
      'dnnc_corrgd' => (denuncia.eval? and (not denuncia.dnnc_ok?)),                     # Denuncia corregida
      'prtcpnts_dclrcn' => true,                                        # Declaración
      'prtcpnts_antcdnts' => true,                                      # Antecedentes
      'infrm_invstgcn' => true,                                         # Informe de investigación
      'mdds_crrctvs' => true,
      'sncns' => true,
      'prnncmnt_dt' => true,
      'rspld_mdds_crrctvs' => true,
      'rspld_sncns' => true,
    }
  end

  # --------------------------------------------------------------------------------------------- TAREAS


  # --------------------------------------------------------------------------------------------- DENUNCIAS

  def krn_dnnc_dc_init(denuncia)
    @krn_cntrl = krn_cntrl(@objeto)

    @dc_lst = {}
    @dc_lst['KrnDenunciante'] = KrnDenunciante.doc_cntrlds
    @dc_lst['KrnDenunciado'] = KrnDenunciado.doc_cntrlds
    @dc_lst['KrnTestigo'] = KrnTestigo.doc_cntrlds

#    load_dc_fl_hsh(denuncia)

  end

  # --------------------------------------------------------------------------------------------- DERIVACIÓN

  def drvcn_mtv
    {
      'rcptn' => 'Recepción derivación de denuncia de nustra responsabilidad.',
      'riohs' => 'RIOHS con protocolo no ha entrado en vigencia.',
      'a41' => 'Aplica artículo 4 inciso primero del Código del trabajo.',
      'seg' => 'Seguimiento de denuncia de empresa externa.',
      'd_optn' => 'Por determinación del denunciante',
      'e_optn' => 'Por determinación de la empresa'
    }
  end


end