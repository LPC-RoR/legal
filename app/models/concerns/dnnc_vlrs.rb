module DnncVlrs
 	extend ActiveSupport::Concern

	# --------------------------------------------------------------------------------------------- VALORES
	# Usamos esta función porque no está clara la utilidad de Concern Valores
	def valor(variable_nm)
		variable = Variable.find_by(variable: variable_nm)
		variable.blank? ? nil : self.valores.find_by(variable_id: variable.id)
	end

	def vlr_drv_inf_dnncnt?
		self.valor('drv_inf_dnncnt').present?
	end

	def drv_inf_dnncnt?
		v = self.valor('drv_inf_dnncnt')
		v.blank? ? nil : v.c_booleano
	end

	def vlr_drv_dnncnt_optn?
		self.valor('drv_dnncnt_optn').present?
	end

	def drv_dnncnt_optn?
		v = self.valor('drv_dnncnt_optn')
		v.blank? ? nil : v.c_booleano
	end

	def vlr_drv_emprs_optn?
		self.valor('drv_emprs_optn').present?
	end

	def drv_emprs_optn?
		v = self.valor('drv_emprs_optn')
		v.blank? ? nil : v.c_booleano
	end

	def vlr_sgmnt_emprs_extrn?
		self.valor('sgmnt_emprs_extrn').present?
	end

	def sgmnt_emprs_extrn?
		v = self.valor('sgmnt_emprs_extrn')
		v.blank? ? nil : v.c_booleano
	end

	def vlr_dnnc_objcn_invstgdr?
		self.valor('dnnc_objcn_invstgdr').present?
	end

	def dnnc_objcn_invstgdr?
		v = self.valor('dnnc_objcn_invstgdr')
		v.blank? ? nil : v.c_booleano
	end

	def vlr_dnnc_rslcn_objcn?
		self.valor('dnnc_rslcn_objcn').present?
	end

	def dnnc_rslcn_objcn?
		v = self.valor('dnnc_rslcn_objcn')
		v.blank? ? nil : v.c_booleano
	end

	def vlr_dnnc_eval_ok?
		self.valor('dnnc_eval_ok').present?
	end

	def dnnc_eval_ok?
		v = self.valor('dnnc_eval_ok')
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