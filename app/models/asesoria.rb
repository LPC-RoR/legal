class Asesoria < ApplicationRecord
	belongs_to :cliente
	belongs_to :tar_servicio, optional: true

	def enlaces
		AppEnlace.where(owner_class: self.class.name, owner_id: self.id)
	end

	def archivos
		AppArchivo.where(owner_class: self.class.name, owner_id: self.id)
	end

	# Hasta aqui revisado!
end
