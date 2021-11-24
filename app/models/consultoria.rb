class Consultoria < ApplicationRecord

	TABLA_FIELDS = 	[
		['consultoria', 'show']
	]

	belongs_to :cliente
	belongs_to :tar_tarifa, optional: true

	def tarifas_disponibles
		self.cliente.tarifas
	end

	def valores
		TarValor.where(owner_class: 'Consultoria', owner_id: self.id)
	end

	def facturaciones
		TarFacturacion.where(owner_class: 'Consultoria', owner_id: self.id)
	end

	def repo
    	AppRepo.where(owner_class: 'Consultoria').find_by(owner_id: self.id)
	end

end
