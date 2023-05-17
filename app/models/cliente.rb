class Cliente < ApplicationRecord
	# tabla de CLINTES
	# 1.- Evaluar has_many tar_facturas

	TABLA_FIELDS = 	[
		's#razon_social'
	]

	has_many :causas
	has_many :consultorias

	validates :rut, valida_rut: true
    validates_presence_of :razon_social

	def tarifas
		TarTarifa.where(owner_class: 'Cliente').where(owner_id: self.id)
	end

	def tarifas_hora
		TarHora.where(owner_class: 'Cliente').where(owner_id: self.id)
	end

	def servicios
		TarServicio.where(owner_class: 'Cliente').where(owner_id: self.id)
	end

	def facturas
		TarFactura.where(owner_class: 'Cliente', owner_id: self.id)
	end

	def facturaciones
    	TarFacturacion.where(cliente_class: 'Cliente', cliente_id: self.id)
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
