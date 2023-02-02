class Consultoria < ApplicationRecord

	TABLA_FIELDS = 	[
		's#consultoria'
	]

	belongs_to :cliente
	belongs_to :tar_tarifa, optional: true

	def tarifas_cliente
		self.cliente.tarifas
	end

	def valores
		TarValor.where(owner_class: 'Consultoria', owner_id: self.id)
	end

	def facturaciones
		TarFacturacion.where(owner_class: 'Consultoria', owner_id: self.id)
	end

	def enlaces
		AppEnlace.where(owner_class: 'Consultoria', owner_id: self.id)
	end

	def repo
    	AppRepo.where(owner_class: 'Consultoria').find_by(owner_id: self.id)
	end

	def reportes
		reportes_clase = RegReporte.where(owner_class: self.class.name)
		reportes_clase.blank? ? nil : reportes_clase.where(owner_id: self.id)
	end

	def registros
    	Registro.where(owner_class: 'Consultoria', owner_id: self.id)
	end
end
