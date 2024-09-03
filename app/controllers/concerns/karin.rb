module Karin
  extend ActiveSupport::Concern

  # --------------------------------------------------------------------------------------------- GENERAL

  def krn_mdl(mdl)
    StModelo.find_by(st_modelo: mdl)
  end

  def krn_doc_cntrlds(mdl)
    krn_mdl(mdl).control_documentos
  end

  def krn_get_dc(mdl, cdg)
    krn_doc_cntrlds(mdl).find_by(codigo: cdg)
  end

  def krn_get_fl(owner, dc)
    dc.blank? ? nil : owner.app_archivos.find_by(control_documento_id: dc.id)
  end

  # --------------------------------------------------------------------------------------------- DENUNCIAS

  # determina cuando se debe subir archivo de denuncia
  def cntrl_dnnc(denuncia)
    denuncia.tipo_declaracion != 'Verbal'
  end

  def cntrl_act(denuncia)
    denuncia.tipo_declaracion == 'Verbal'
  end

  # determina cuando se debe subir archivo de certificado de recepción de derivacción de denuncia
  def cntrl_crtfcd(denuncia)
    denuncia.dnnte_derivacion != true
  end

  # determina cuando se debe subir archivo notificación de inicio de investigación por parte de la DT
  def cntrl_ntfccn(denuncia)
    denuncia.receptor_denuncia.receptor_denuncia == 'DT'
  end

  def krn_dnnc_dc_init(denuncia)
      @dc_dnnc = krn_get_dc('KrnDenuncia', 'krn_denuncia')
      @dc_act = krn_get_dc('KrnDenuncia', 'krn_acta')
      @dc_crtfcd = krn_get_dc('KrnDenuncia', 'krn_certificado')
      @dc_ntfccn = krn_get_dc('KrnDenuncia', 'krn_notificacion')

      @act = krn_get_fl(denuncia, @dc_act)
      @dnnc = krn_get_fl(denuncia, @dc_dnnc)
      @crtfcd = krn_get_fl(denuncia, @dc_crtfcd)
      @ntfccn = krn_get_fl(denuncia, @dc_ntfccn)
  end

  # --------------------------------------------------------------------------------------------- DENUNCIANTE

  # determina cuando se debe subir archivo de denuncia
  def cntrl_diat_diep(dnncnt)
    true
  end

  def krn_dnncnts_dc_init(denuncia)
      @dc_diat_diep = krn_get_dc('KrnDenunciante', 'krn_dnncnt_diat_diep')

      @diat_diep = {}
      denuncia.krn_denunciantes.each do |dnncnt|
        @diat_diep[dnncnt.id] = krn_get_fl(dnncnt, @dc_diat_diep)
      end
  end

end