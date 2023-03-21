class Causa < ApplicationRecord
	# Tabla de CAUSAS
	# pertenece a tar_tarifa

	TIPOS=['Juicio', 'Demanda']

	TABLA_FIELDS = 	[
		'identificador',
		's#causa',
#		'tipo_causa:tipo_causa'
	]

	belongs_to :cliente
	belongs_to :tar_tarifa, optional: true
	belongs_to :tar_hora, optional: true

	belongs_to :tipo_causa, optional: true

    validates_presence_of :identificador, :causa

	def tarifas_cliente
		self.cliente.tarifas
	end

	def tarifas_hora_cliente
		self.cliente.tarifas_hora
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

	def reportes
		reportes_clase = RegReporte.where(owner_class: self.class.name)
		reportes_clase.blank? ? nil : reportes_clase.where(owner_id: self.id)
	end

	def registros
    	Registro.where(owner_class: 'Causa', owner_id: self.id)
	end

	def valores_cuantia
		TarValorCuantia.where(owner_class: 'Causa', owner_id: self.id)
	end

	def v_cuantia
		[self.valores_cuantia.map {|vc| vc.valor}.sum, self.valores_cuantia.map {|vc| vc.valor_uf}.sum]
	end

end
