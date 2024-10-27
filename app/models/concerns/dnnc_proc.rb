module DnncProc
 	extend ActiveSupport::Concern

	def prtl_cndtn
		{
			fecha_dt: {
				cndtn: self.fecha_hora_dt.present?,
				trsh: true
			},
			externa_id: {
				cndtn: self.krn_empresa_externa.present?,
				trsh: ( not self.dnncnts?)
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
				cndtn: self.vlr_seguimiento?,
				trsh: (not self.mdds?)
			},
			recpcn_ok: {
				cndtn: self.rcpcnd?,
				trsh: false
			},
			obligatoria: {
				cndtn: self.drv_dt?,
				trsh: (not self.mdds?)
			},
			inf_dnncnt: {
				cndtn: (self.vlr_inf_dnncnt?),
				trsh: (not self.vlr_d_optn_invstgcn?)
			},
			d_optn_invstgcn: {
				cndtn: (self.vlr_d_optn_invstgcn? or self.drv_dt?),
				trsh: (not self.vlr_e_optn_invstgcn?)
			},
			e_optn_invstgcn: {
				cndtn: (self.vlr_e_optn_invstgcn? or self.drv_dt?),
				trsh: (not self.vlr_dnnc_infrm_invstgcn_dt?)
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