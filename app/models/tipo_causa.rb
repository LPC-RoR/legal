class TipoCausa < ApplicationRecord

	has_many :causas
	has_many :audiencias


	has_many :var_tp_causas
	has_many :variables, through: :var_tp_causas

	has_many :tar_tarifas
	has_many :tar_variable_bases

	def control_documentos
		ControlDocumento.where(owner_class: self.class.name, owner_id: self.id).order(:orden)
	end

end
