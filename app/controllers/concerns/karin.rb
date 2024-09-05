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
    denuncia.invstgdr_dt?
  end

  def krn_dnnc_dc_init(denuncia)
      @dc_dnnc = KrnDenuncia.doc_cntrlds.get_archv('krn_denuncia')
      @dc_act = KrnDenuncia.doc_cntrlds.get_archv('krn_acta')
      @dc_crtfcd = KrnDenuncia.doc_cntrlds.get_archv('krn_certificado')
      @dc_ntfccn = KrnDenuncia.doc_cntrlds.get_archv('krn_notificacion')

      @act = denuncia.rep_archivos.get_dc_archv(@dc_act)
      @dnnc = denuncia.rep_archivos.get_dc_archv(@dc_dnnc)
      @crtfcd = denuncia.rep_archivos.get_dc_archv(@dc_crtfcd)
      @ntfccn = denuncia.rep_archivos.get_dc_archv(@dc_ntfccn)

      @entdd_invstgdr = @objeto.entdd_invstgdr
  end

  # --------------------------------------------------------------------------------------------- DENUNCIANTE

  # determina cuando se debe subir archivo de denuncia
  def cntrl_diat_diep(dnncnt)
    true
  end

  def krn_dnncnts_dc_init(denuncia)
      @dc_diat_diep = KrnDenunciante.doc_cntrlds.get_archv('krn_dnncnt_diat_diep')

      @diat_diep = {}
      denuncia.krn_denunciantes.each do |dnncnt|
        puts "************************************* krn_dnncnts_dc_init"
        puts @dc_diat_diep.blank?
        puts denuncia.krn_denunciantes.count
        puts dnncnt.rep_archivos.count
        @diat_diep[dnncnt.id] = dnncnt.rep_archivos.get_dc_archv(@dc_diat_diep)
      end
  end

end