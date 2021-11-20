class Cliente < ApplicationRecord
	TABLA_FIELDS = 	[
		['razon_social', 'show']
	]

	has_many :causas

	def tarifas
		TarTarifa.where(owner_class: 'Cliente').where(owner_id: self.id)
	end

	def servicios
		TarServicio.where(owner_class: 'Cliente').where(owner_id: self.id)
	end
end
