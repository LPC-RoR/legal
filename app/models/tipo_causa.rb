class TipoCausa < ApplicationRecord

	has_many :causas
	has_many :audiencias
	has_many :variables

	has_many :tar_tarifas

	def control_documentos
		ControlDocumento.where(owner_class: self.class.name, owner_id: self.id).order(:orden)
	end

end
