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

      'dnnc_evlcn' => (dnnc.eval? and (not dnnc.dnnc_ok?)),
      'dnnc_corrgd' => (dnnc.eval? and (not dnnc.dnnc_ok?)),            # Denuncia corregida

      'prtcpnts_dclrcn' => true,                                        # Declaración
      'prtcpnts_antcdnts' => true,                                      # Antecedentes

      'infrm_invstgcn' => true,                                         # Informe de investigación
      'mdds_crrctvs' => true,
      'sncns' => true,

      'prnncmnt_dt' => true,
      'dnnc_mdds_sncns' => true,
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