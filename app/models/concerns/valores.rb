module Valores
 	extend ActiveSupport::Concern

	def m_vlr(mdl, code)
		vrbl = Variable.find_by(variable: code)
		vrbl.blank? ? nil : mdl.valores.find_by(variable_id: vrbl.id)
	end

	def m_vlr?(mdl, code)
		vlr(mdl, code).present?
	end

	def vlr(mdl, code)
		mv = m_vlr(mdl, code)
		mv.blank? ? nil : mv.c_booleano
	end

end