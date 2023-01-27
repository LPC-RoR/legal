class Causa < ApplicationRecord
	# Tabla de CAUSAS
	# pertenece a tar_tarifa

	TIPOS=['Juicio', 'Demanda']

	TABLA_FIELDS = 	[
		['identificador', 'normal'],
		['tipo_causa:tipo_causa', 'normal'],
		['causa', 'show']
	]

	belongs_to :cliente
	belongs_to :tar_tarifa, optional: true

	belongs_to :tipo_causa

	def tarifas_cliente
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

	def registros
    	Registro.where(owner_class: 'Causa', owner_id: self.id)
	end

end
