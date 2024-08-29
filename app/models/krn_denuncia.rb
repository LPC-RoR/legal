class KrnDenuncia < ApplicationRecord
	belongs_to :cliente, optional: true
	belongs_to :motivo_denuncia
	belongs_to :receptor_denuncia
	belongs_to :dependencia_denunciante

	has_one :krn_denunciante

	has_many :krn_denunciados

	def owner
#		self.cliente_id.blank? ? self.empresa : self.cliente
		self.cliente
	end

	def app_archivos
		AppArchivo.where(owner_class: self.class.name, owner_id: self.id)
	end
end
