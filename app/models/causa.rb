class Causa < ApplicationRecord
	TABLA_FIELDS = 	[
		['causa', 'show']
	]

	belongs_to :cliente
	belongs_to :tar_tarifa, optional: true

	def valores
		TarValor.where(owner_class: 'Causa', owner_id: self.id)
	end

	def facturaciones
		TarFacturacion.where(owner_class: 'Causa', owner_id: self.id)
	end
end
