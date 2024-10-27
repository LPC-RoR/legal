module Dnnc
 	extend ActiveSupport::Concern

	PRESENTADORES = ['Denunciante', 'Representante']

	def css_id
		'dnnc'
	end

	# --------------------------------------------------------------------------------------------- VALORES

	def valor(variable_nm)
		variable = Variable.find_by(variable: variable_nm)
		variable.blank? ? nil : self.valores.find_by(variable_id: variable.id)
	end

	# ------------------------------------------------------------------------ INGRS

	def prsncl?
		self.via_declaracion == KrnDenuncia::VIAS_DENUNCIA[0]
	end

	def rprsntnt?
		self.presentado_por == KrnDenuncia::TIPOS_DENUNCIANTE[1]
	end

	def end_drv_dt?
		self.drv_dt? ? self.fecha_hora_dt.present? : true
	end

	def end_rcp_externa?
		self.rcp_externa? ? self.krn_empresa_externa.present? : true
	end

	def end_prsncl?
		self.prsncl? ? self.tipo_declaracion.present? : true
	end

	def end_rprsntnt?
		self.rprsntnt? ? self.representante.present? : true
	end

	def end_ingrs?
		self.end_drv_dt? and self.end_rcp_externa? and self.end_prsncl? and self.end_rprsntnt?
	end

	# ------------------------------------------------------------------------ PRTCPNTS

	def dnncnts?
		self.krn_denunciantes.any?
	end

	def dnncds?
		self.krn_denunciados.any?
	end

	def prtcpnts?
		self.dnncnts? and self.dnncds?
	end

	def prtcpnts_ok?
		self.prtcpnts? and (not self.krn_denunciantes.rgstrs_fail?) and (not self.krn_denunciados.rgstrs_fail?)
	end

	# ------------------------------------------------------------------------ MDDS

	def mdds?
		self.krn_lst_medidas.any?
	end

	# ------------------------------------------------------------------------ DIAT/DIEP

	# ------------------------------------------------------------------------ SGMNT

	def dsply_sgmnt?
		self.prtcpnts_ok? and (self.rcp_dt? or self.drv_dt? or self.externa?) and (self.drvcn_rchzd? or self.sgmnt_drvcn_externa?)
	end

	def drvcn_rchzd?
		self.rcp_externa? and self.externa? and (self.seguimiento? == false)
	end

	def sgmnt_drvcn_externa?
		self.rcp_externa? and self.externa?
	end

	def vlr_seguimiento
		vlr = self.valor('Seguimiento')
		vlr.blank? ? nil : vlr
	end

	def vlr_seguimiento?
		self.vlr_seguimiento.present?
	end

	def seguimiento?
		self.vlr_seguimiento.blank? ? nil : self.vlr_seguimiento.c_booleano
	end

	def dnnc_sgmnt_end?
		self.end_ingrs? and (self.sgmnt_drvcn_externa? ? self.vlr_seguimiento? : true)
	end

	# ------------------------------------------------------------------------ DRVCNS

	def dsply_drvcns?
		self.dnnc_sgmnt_end? and self.prtcpnts_ok? and self.mdds? and (not self.invstgcn_dt?)
	end

	def rcpcn?
		self.rcp_externa? and self.empresa?
	end

	def rcpcnd?
		self.rcpcn? and ( self.krn_derivaciones.map {|drv| drv.tipo}.include?('Recepción') )
	end

	def extrn_prsncl?
		self.rcp_empresa? and self.externa?
	end

	def drvcns_on?
		self.rcpcn? ? self.rcpcnd? : (self.rcp_dt? ? false : self.empresa?)
	end

	def riohs_off?
		false
	end

	# A alguno de los participantes se le aplica el Artículo 4 parrafo 1
	def art4_1?
		self.krn_denunciantes.art4_1? or self.krn_denunciados.art4_1?
	end

	def dt_obligatoria?
		self.extrn_prsncl? ? self.art4_1? : (self.riohs_off? or self.art4_1?)
	end

	def drvcns?
		self.krn_derivaciones.any?
	end

	def no_drvcns?
		self.krn_derivaciones.empty?
	end

	def vlr_inf_dnncnt
		vlr = self.valor('inf_dnncnt')
		vlr.blank? ? nil : vlr
	end

	def vlr_inf_dnncnt?
		self.vlr_inf_dnncnt.present?
	end

	def inf_dnncnt?
		self.vlr_inf_dnncnt.blank? ? nil : self.vlr_inf_dnncnt.c_booleano
	end

	def vlr_d_optn_invstgcn
		vlr = self.valor('d_optn_invstgcn')
		vlr.blank? ? nil : vlr
	end

	def vlr_d_optn_invstgcn?
		self.vlr_d_optn_invstgcn.present?
	end

	def d_optn_invstgcn?
		self.vlr_d_optn_invstgcn.blank? ? nil : self.vlr_d_optn_invstgcn.c_booleano
	end

	def vlr_e_optn_invstgcn
		vlr = self.valor('e_optn_invstgcn')
		vlr.blank? ? nil : vlr
	end

	def vlr_e_optn_invstgcn?
		self.vlr_e_optn_invstgcn.present?
	end

	def e_optn_invstgcn?
		self.vlr_e_optn_invstgcn.blank? ? nil : self.vlr_e_optn_invstgcn.c_booleano
	end

	def dnnc_drvcns_end?
		self.dnnc_sgmnt_end? and (self.rcp_dt? or self.drv_dt? or self.drv_externa? or self.vlr_e_optn_invstgcn?)
	end

	def invstgcn_on?
		self.invstgcn_emprs? or self.invstgcn_dt? or self.invstgcn_extrn?
	end


	# ------------------------------------------------------------------------ INFRMCN_DT

	def vlr_dnnc_infrm_invstgcn_dt
		vlr = self.valor('dnnc_infrm_invstgcn_dt')
		vlr.blank? ? nil : vlr
	end

	def vlr_dnnc_infrm_invstgcn_dt?
		self.vlr_dnnc_infrm_invstgcn_dt.present?
	end

	def dnnc_infrm_invstgcn_dt?
		self.vlr_dnnc_infrm_invstgcn_dt.blank? ? nil : self.vlr_dnnc_infrm_invstgcn_dt.c_booleano
	end

	# ------------------------------------------------------------------------ INVSTGCN

	def invstgdr?
		self.krn_investigador_id.present?
	end

	def vlr_dnnc_leida
		vlr = self.valor('dnnc_leida')
		vlr.blank? ? nil : vlr
	end

	def vlr_dnnc_leida?
		self.vlr_dnnc_leida.present?
	end

	def dnnc_leida?
		self.vlr_dnnc_leida.blank? ? nil : self.vlr_dnnc_leida.c_booleano
	end

	def vlr_dnnc_incnsstnt
		vlr = self.valor('dnnc_incnsstnt')
		vlr.blank? ? nil : vlr
	end

	def vlr_dnnc_incnsstnt?
		self.vlr_dnnc_incnsstnt.present?
	end

	def dnnc_incnsstnt?
		self.vlr_dnnc_incnsstnt.blank? ? nil : self.vlr_dnnc_incnsstnt.c_booleano
	end

	def vlr_dnnc_incmplt
		vlr = self.valor('dnnc_incmplt')
		vlr.blank? ? nil : vlr
	end

	def vlr_dnnc_incmplt?
		self.vlr_dnnc_incmplt.present?
	end

	def dnnc_incmplt?
		self.vlr_dnnc_incmplt.blank? ? nil : self.vlr_dnnc_incmplt.c_booleano
	end

	def eval?
		self.vlr_dnnc_incmplt? and self.vlr_dnnc_incnsstnt?
	end

	def dnnc_ok?
		self.dnnc_incnsstnt? == false and self.dnnc_incmplt? == false
	end

	def any_dclrcn?
		self.krn_denunciantes.map {|dte| dte.dclrcn?}.include?(true) or self.krn_denunciados.map {|dte| dte.dclrcn?}.include?(true)
	end

	def dclrcn?
		self.invstgcn_emprs? and self.any_dclrcn? and ( not self.krn_denunciantes.map {|dte| dte.dclrcn?}.include?(false) ) and ( not self.krn_denunciados.map {|dte| dte.dclrcn?}.include?(false) )
	end

	# ------------------------------------------------------------------------ CIERRE INVSTGCN

	def vlr_dnnc_crr_dclrcns
		vlr = self.valor('dnnc_crr_dclrcns')
		vlr.blank? ? nil : vlr
	end

	def vlr_dnnc_crr_dclrcns?
		self.vlr_dnnc_crr_dclrcns.present?
	end

	def dnnc_crr_dclrcns?
		self.vlr_dnnc_crr_dclrcns.blank? ? nil : self.vlr_dnnc_crr_dclrcns.c_booleano
	end

	def sncns?
		self.krn_lst_medidas.sncns.any?
	end

	def vlr_dnnc_infrm_dt
		vlr = self.valor('dnnc_infrm_dt')
		vlr.blank? ? nil : vlr
	end

	def vlr_dnnc_infrm_dt?
		self.vlr_dnnc_infrm_dt.present?
	end

	def dnnc_infrm_dt?
		self.vlr_dnnc_infrm_dt.blank? ? nil : self.vlr_dnnc_infrm_dt.c_booleano
	end

end