module Dnnc
 	extend ActiveSupport::Concern

	PRESENTADORES = ['Denunciante', 'Representante']

	def css_id
		'dnnc'
	end

	def prtl_cndtn
		{
			fecha: {
				cndtn: self.fecha?,
				trsh: (self.trsh_fecha?)
			},
			fecha_dt: {
				cndtn: self.fecha_dt?,
				trsh: true
			},
			externa_id: {
				cndtn: self.externa_id?,
				trsh: (not self.via_declaracion?)
			},
			via: {
				cndtn: self.via_declaracion?,
				trsh: (not self.tipo_declaracion?)
			},
			tipo: {
				cndtn: self.tipo_declaracion?,
				trsh: (not self.presentado_por?)
			},
			presentada: {
				cndtn: self.presentado_por?,
				trsh: self.trsh_presentada?
			},
			representante: {
				cndtn: self.representante?,
				trsh: (not self.dnncnts?)
			},
			sgmnt_drvcn: {
				cndtn: self.vlr_seguimiento?,
				trsh: (not self.mdds?)
			},
			obligatoria: {
				cndtn: self.drv_dt?,
				trsh: (not self.mdds?)
			},
			recpcn_ok: {
				cndtn: self.drvcns?,
				trsh: false
			},
			inf_dnncnt: {
				cndtn: (self.vlr_inf_dnncnt?),
				trsh: (not self.vlr_d_optn_emprs?)
			},
			drvcn_dnncnt: {
				cndtn: self.drvcns?,
				trsh: false
			},
			d_optn_emprs: {
				cndtn: (self.vlr_d_optn_emprs? or self.drv_dt?),
				trsh: (not self.vlr_e_optn_emprs?)
			},
			e_optn_emprs: {
				cndtn: (self.vlr_e_optn_emprs? or self.drv_dt?),
				trsh: (not self.mdds?)
			},
			dnnc_infrm_invstgcn_dt: {
				cndtn: self.vlr_dnnc_infrm_invstgcn_dt?,
				trsh: (not self.invstgdr?)
			},
			invstgdr: {
				cndtn: self.invstgdr?,
				trsh: (not self.vlr_dnnc_leida?)
			},
			dnnc_leida: {
				cndtn: self.vlr_dnnc_leida?,
				trsh: (not self.vlr_dnnc_incnsstnt?)
			},
			dnnc_incnsstnt: {
				cndtn: self.vlr_dnnc_incnsstnt?,
				trsh: (not self.vlr_dnnc_incmplt?)
			},
			dnnc_incmplt: {
				cndtn: self.vlr_dnnc_incmplt?,
				trsh: (not self.vlr_dnnc_crr_dclrcns?)
			},
			dnnc_crr_dclrcns: {
				cndtn: self.vlr_dnnc_crr_dclrcns?,
				trsh: (not self.vlr_dnnc_infrm_dt?)
			},
			dnnc_infrm_dt: {
				cndtn: self.vlr_dnnc_infrm_dt?,
				trsh: (not false)
			},
		}
	end

	def cndtn(code)
		self.prtl_cndtn[code].blank? ? false : (self.prtl_cndtn[code][:cndtn].blank? ? false : self.prtl_cndtn[code][:cndtn])
	end

	def trsh(code)
		self.prtl_cndtn[code].blank? ? false : (self.prtl_cndtn[code][:trsh].blank? ? false : self.prtl_cndtn[code][:trsh])
	end

	# --------------------------------------------------------------------------------------------- VALORES

	def valor(variable_nm)
		variable = Variable.find_by(variable: variable_nm)
		variable.blank? ? nil : self.valores.find_by(variable_id: variable.id)
	end

	# ------------------------------------------------------------------------ INGRS

	def fecha?
		 self.fecha_hora.present?
	end

	def trsh_fecha?
		self.rcp_externa? ? (not self.externa_id?) : (not self.via_declaracion? )
	end

	def fecha_dt?
		 self.fecha_hora_dt.present?
	end

	def externa_id?
		self.krn_empresa_externa.present?
	end

	def cndtn_externa_id?
		
	end

	def dsply_via?
		self.rcp_externa? ? self.externa_id? : fecha?
	end

	def via_declaracion?
		self.via_declaracion.present?
	end

	def tipo_declaracion?
		self.tipo_declaracion.present?
	end

	def presentado_por?
		self.presentado_por.present?
	end

	def trsh_presentada?
		self.activa_representante? ? (not self.representante?) : (not self.dnncnts?)
	end

	def activa_representante?
		self.presentado_por == PRESENTADORES[1]
	end

	def representante?
		self.representante.present?
	end

	# ------------------------------------------------------------------------ DIAT/DIEP

	def dnnc_ingrs?
		self.activa_representante? ? self.representante? : self.presentado_por?
	end

	def dnncnts?
		self.krn_denunciantes.any?
	end

	def prtcpnts?
		self.dnncnts? and self.krn_denunciados.any?
	end

	# ------------------------------------------------------------------------ SGMNT

	def dsply_sgmnt?
		self.prtcpnts? and (self.rcp_dt? or self.drv_dt? or self.externa?)
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

	def drvcn_rchzd?
		self.rcp_externa? and self.externa? and (self.seguimiento? == false)
	end

	def dnnc_sgmnt?
		self.dsply_sgmnt? ? (self.sgmnt_drvcn_externa? ? self.drvcn_rchzd? : true )  : true
	end

	# ------------------------------------------------------------------------ DRVCNS

	def dsply_drvcns?
		self.prtcpnts?
	end

	def drvcns?
		self.krn_derivaciones.any?
	end

	def no_drvcns?
		self.krn_derivaciones.empty?
	end

	def riohs_off?
		false
	end

	# A alguno de los participantes se le aplica el Artículo 4 parrafo 1
	def art4_1?
		self.krn_denunciantes.art4_1? or self.krn_denunciados.art4_1?
	end

	def dt_obligatoria?
		self.riohs_off? or self.art4_1?
	end

	def rcpcn?
		self.rcp_externa? and self.empresa?
	end

	def extrn_prsncl?
		self.rcp_empresa? and self.externa?
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

	def vlr_d_optn_emprs
		vlr = self.valor('d_optn_emprs')
		vlr.blank? ? nil : vlr
	end

	def vlr_d_optn_emprs?
		self.vlr_d_optn_emprs.present?
	end

	def d_optn_emprs?
		self.vlr_d_optn_emprs.blank? ? nil : self.vlr_d_optn_emprs.c_booleano
	end

	def vlr_e_optn_emprs
		vlr = self.valor('e_optn_emprs')
		vlr.blank? ? nil : vlr
	end

	def vlr_e_optn_emprs?
		self.vlr_e_optn_emprs.present?
	end

	def e_optn_emprs?
		self.vlr_e_optn_emprs.blank? ? nil : self.vlr_e_optn_emprs.c_booleano
	end


	# ------------------------------------------------------------------------ MDDS

#	def dsply_mdds?
#		self.prtcpnts?
#		self.rcp_dt? or (self.drv_dt? == true) or (self.drv_externa? == true) or (self.e_optn_emprs? == true)
#	end

	def mdds?
		self.krn_lst_medidas.any?
	end

	# ------------------------------------------------------------------------ INFRMCN_DT

	def dsply_infrm_invstgcn_dt?
		self.krn_lst_medidas.any?
	end

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

	def dsply_dclrcn?
		false
	end

	# ------------------------------------------------------------------------ CIERRE INVSTGCN

	def dsply_cierre?
		self.prtcpnts?
	end

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