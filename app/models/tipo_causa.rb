class TipoCausa < ApplicationRecord

	TABLA_FIELDS = 	[
		'tipo_causa'
	]

	has_many :causas
	has_many :audiencias
	has_many :variables

	def control_documentos
		ControlDocumento.where(owner_class: self.class.name, owner_id: self.id).order(:orden)
	end

end
