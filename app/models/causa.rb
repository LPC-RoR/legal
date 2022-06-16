class Causa < ApplicationRecord

	TIPOS=['Juicio', 'Demanda']

	TABLA_FIELDS = 	[
		['identificador', 'normal'],
		['tipo', 'normal'],
		['causa', 'show']
	]

	belongs_to :cliente
	belongs_to :tar_tarifa, optional: true

	def tarifas_disponibles
		self.cliente.tarifas
	end

	def valores
		TarValor.where(owner_class: 'Causa', owner_id: self.id)
	end

	def facturaciones
		TarFacturacion.where(owner_class: 'Causa', owner_id: self.id)
	end

	def enlaces
		AppEnlace.where(owner_class: 'Causa', owner_id: self.id)
	end

	def repo
    	AppRepo.where(owner_class: 'Causa').find_by(owner_id: self.id)
	end

end
