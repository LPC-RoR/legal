module Karin
  extend ActiveSupport::Concern

  # --------------------------------------------------------------------------------------------- GENERAL

  #Control de despliegue de Archivos

  def krn_cntrl(denuncia)
    {
      'dnnc_denuncia' => denuncia.tipo_declaracion != 'Verbal',     # Denuncia se presenta por escrito
      'dnnc_acta' => denuncia.tipo_declaracion == 'Verbal',         # Denuncia se presenta en forma verbal
      'dnnc_notificacion' => denuncia.rcp_dt?,                      # Denuncia derivada a la DT o recibida por ella
      'dnnc_certificado' => denuncia.drv_dt? == true,               # DT certifica que recibió la denuncia que le derivamos
      'dnncnt_diat_diep' => true,
      'dnnc_corrgd' => (denuncia.dnnc_errr?),                       # Denuncia corregida
      'dnnc_dclrcn' => true,                                        # Declaración
      'dnnc_antcdnts' => true,                                      # Antecedentes
      'dnnc_infrm' => true,                                         # Informe de investigación
      'krn_antcdnt_objcn' => true,
      'krn_dnncd_antcdnts' => true,
      'krn_dnncnt_antcdnts' => true,
      'krn_tstg_dclrcn' => true,
      'krn_tstg_antcdnt' => true,
      'krn_informe' => true,
      'krn_crtfcd_infrm' => true,
      'krn_pronunciamiento' => true,
      'krn_impugnacion' => true
    }
  end

  # --------------------------------------------------------------------------------------------- TAREAS


  # --------------------------------------------------------------------------------------------- DENUNCIAS

  def krn_dnnc_dc_init(denuncia)
    @krn_cntrl = krn_cntrl(@objeto)

    @dc_lst = {}
    @dc_lst['KrnDenuncia'] = KrnDenuncia.doc_cntrlds
    @dc_lst['KrnDenunciante'] = KrnDenunciante.doc_cntrlds
    @dc_lst['KrnDenunciado'] = KrnDenunciado.doc_cntrlds
    @dc_lst['KrnTestigo'] = KrnTestigo.doc_cntrlds

#    load_dc_fl_hsh(denuncia)

  end

  # --------------------------------------------------------------------------------------------- DERIVACIÓN

  def drvcn_mtv
    {
      'riohs' => 'RIOHS con protocolo no ha entrado en vigencia.',
      'a41' => 'Aplica artículo 4 inciso primero del Código del trabajo.',
      'seg' => 'Seguimiento de denuncia de empresa externa.',
      'r_multi' => 'Recepción derivación de denuncia multi-empresa.',
      'd_optn' => 'Por determinación del denunciante',
      'e_optn' => 'Por determinación de la empresa'
    }
  end


end