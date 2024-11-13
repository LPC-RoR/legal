module DnncProc
 	extend ActiveSupport::Concern

	def prtl_cndtn
		{
			drv_fecha_dt: {
				cndtn: self.fecha_hora_dt.present?,
				trsh: true
			},
			externa_id: {
				cndtn: self.krn_empresa_externa.present?,
				trsh: (not self.invstgdr?)
			},
			tipo: {
				# ['Escrita', 'Verbal']
				cndtn: self.tipo_declaracion.present?,
				trsh: (not self.dnncnts?)
			},
			representante: {
				cndtn: self.representante.present?,
				trsh: (not self.dnncnts?)
			},
			sgmnt_drvcn: {
				cndtn: self.vlr_flg_sgmnt?,
				trsh: (not self.mdds?)
			},
			drv_rcp_externa: {
				cndtn: (not self.no_drvcns?),
				trsh: false
			},
			recpcn_ok: {
				cndtn: self.rcpcnd?,
				trsh: false
			},
			drv_dt_oblgtr: {
				cndtn: self.on_dt?,
				trsh: (not self.mdds?)
			},
			drv_inf_dnncnt: {
				cndtn: (self.vlr_drv_inf_dnncnt?),
				trsh: (not (self.vlr_drv_dnncnt_optn? or self.drvcns?))
			},
			drv_dnncnt_optn: {
				cndtn: (self.vlr_drv_dnncnt_optn?),
				trsh: (not (self.drv_emprs_optn? or self.drvcns?))
			},
			drv_emprs_optn: {
				cndtn: (self.drv_emprs_optn? or self.drv_dt?),
				trsh: (not (self.fecha_trmtcn.present? or self.drvcns?))
			},
			dnnc_fecha_trmtcn: {
				cndtn: self.fecha_trmtcn.present?,
				trsh: (not self.invstgdr?)
			},
			invstgdr: {
				cndtn: self.invstgdr?,
				trsh: (not (self.vlr_dnnc_leida? or self.vlr_dnnc_objcn_invstgdr?))
			},
			dnnc_objcn_invstgdr: {
				cndtn: (self.vlr_dnnc_objcn_invstgdr?),
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
				trsh: (not (self.any_dclrcn? or self.fecha_hora_corregida.present?))
			},
			dnnc_fecha_crrgd: {
				cndtn: self.fecha_hora_corregida.present?,
				trsh: (not self.any_dclrcn?)
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

end