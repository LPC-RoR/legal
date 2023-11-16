class Cliente < ApplicationRecord
	# tabla de CLINTES
	# 1.- Evaluar has_many tar_facturas

	TABLA_FIELDS = 	[
		's#razon_social'
	]

	has_many :causas
	has_many :asesorias
	has_many :consultorias

	has_many :tar_aprobaciones

	has_many :org_areas

	validates :rut, valida_rut: true
    validates_presence_of :razon_social, :tipo_cliente

    def d_rut
    	self.rut.gsub(' ', '').insert(-8, '.').insert(-5, '.').insert(-2, '-')
    end

	def enlaces
		AppEnlace.where(owner_class: self.class.name, owner_id: self.id)
	end

	def archivos
		AppArchivo.where(owner_class: self.class.name, owner_id: self.id)
	end

	#Solo para que funcione ser_redireccion
	def repositorio
    	AppRepositorio.where(owner_class: self.class.name).find_by(owner_id: self.id)
	end

	# Hasta aqui revisado!

	def tarifas
		TarTarifa.where(owner_class: self.class.name).where(owner_id: self.id)
	end

	def tarifas_hora
		TarHora.where(owner_class: self.class.name).where(owner_id: self.id)
	end

	def servicios
		TarServicio.where(owner_class: self.class.name).where(owner_id: self.id)
	end

	def facturas
		TarFactura.where(owner_class: self.class.name, owner_id: self.id)
	end

	def facturaciones
    	TarFacturacion.where(cliente_class: self.class.name, cliente_id: self.id)
	end

	def aprobaciones
		self.facturaciones.where(estado: 'aprobación').order(created_at: :desc)
	end

	def facturaciones_pendientes
		self.facturaciones.where(estado: 'aprobado', tar_factura_id: nil)
	end

	# DEPRECATED
	def aprob_total_uf
		self.aprobaciones.map {|facturacion| facturacion.monto_uf}.sum
	end

	# DEPRECATED
	def aprob_total_pesos
		self.aprobaciones.map {|facturacion| facturacion.monto_pesos}.sum
	end

	def uf_dia
		uf = TarUfSistema.find_by(fecha: Time.zone.today.to_date)
		uf.blank? ? 0 : uf.valor
	end

	def monto_factura_aprobacion_pesos
		self.facturaciones.where(tar_factura_id: nil).map {|fctrcn| fctrcn.moneda == 'Pesos' ? fctrcn.monto : fctrcn.monto * self.uf_dia }.sum
	end

	def monto_factura_aprobacion_uf
		self.facturaciones.where(tar_factura_id: nil).map {|fctrcn| fctrcn.moneda == 'Pesos' ? fctrcn.monto / self.uf_dia : fctrcn.monto }.sum
	end

end
