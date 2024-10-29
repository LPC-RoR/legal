module DnncVlrs
 	extend ActiveSupport::Concern

	def vlr_flg_sgmnt?
		self.valor('flg_sgmnt').present?
	end

	def flg_sgmnt?
		v = self.valor('flg_sgmnt')
		v.blank? ? nil : v.c_booleano
	end

	def vlr_inf_dnncnt?
		self.valor('inf_dnncnt').present?
	end

	def inf_dnncnt?
		v = self.valor('inf_dnncnt')
		v.blank? ? nil : v.c_booleano
	end

	def vlr_d_optn_invstgcn?
		self.valor('d_optn_invstgcn').present?
	end

	def d_optn_invstgcn?
		v = self.valor('d_optn_invstgcn')
		v.blank? ? nil : v.c_booleano
	end

	def vlr_e_optn_invstgcn?
		self.valor('e_optn_invstgcn').present?
	end

	def e_optn_invstgcn?
		v = self.valor('e_optn_invstgcn')
		v.blank? ? nil : v.c_booleano
	end

	def vlr_dnnc_infrm_invstgcn_dt?
		self.valor('dnnc_infrm_invstgcn_dt').present?
	end

	def dnnc_infrm_invstgcn_dt?
		v = self.valor('dnnc_infrm_invstgcn_dt')
		v.blank? ? nil : v.c_booleano
	end

	def vlr_objcn_invstgdr?
		self.valor('objcn_invstgdr').present?
	end

	def objcn_invstgdr?
		v = self.valor('objcn_invstgdr')
		v.blank? ? nil : v.c_booleano
	end

	def vlr_dnnc_leida?
		self.valor('dnnc_leida').present?
	end

	def dnnc_leida?
		v = self.valor('dnnc_leida')
		v.blank? ? nil : v.c_booleano
	end

	def vlr_dnnc_incnsstnt?
		self.valor('dnnc_incnsstnt').present?
	end

	def dnnc_incnsstnt?
		v = self.valor('dnnc_incnsstnt')
		v.blank? ? nil : v.c_booleano
	end

	def vlr_dnnc_incmplt?
		self.valor('dnnc_incmplt').present?
	end

	def dnnc_incmplt?
		v = self.valor('dnnc_incmplt')
		v.blank? ? nil : v.c_booleano
	end

	def vlr_dnnc_crr_dclrcns?
		self.valor('dnnc_crr_dclrcns').present?
	end

	def dnnc_crr_dclrcns?
		v = self.valor('dnnc_crr_dclrcns')
		v.blank? ? nil : v.c_booleano
	end

	def vlr_dnnc_infrm_dt?
		self.valor('dnnc_infrm_dt').present?
	end

	def dnnc_infrm_dt?
		v = self.valor('dnnc_infrm_dt')
		v.blank? ? nil : v.c_booleano
	end

end