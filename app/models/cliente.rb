class Cliente < ApplicationRecord
	# tabla de CLINTES
	# 1.- Evaluar has_many tar_facturas

	TABLA_FIELDS = 	[
		's#razon_social'
	]

	has_many :causas
	has_many :consultorias

	def tarifas
		TarTarifa.where(owner_class: 'Cliente').where(owner_id: self.id)
	end

	def servicios
		TarServicio.where(owner_class: 'Cliente').where(owner_id: self.id)
	end

	def facturacion_pendiente
    	TarFacturacion.where(id: TarFacturacion.where(estado: 'ingreso').map {|tarf| tarf.id if tarf.padre.cliente.id == self.id})
	end
end
