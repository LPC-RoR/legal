class TarFacturacion < ApplicationRecord

	TABLA_FIELDS = [
		'glosa',
		'm#monto_ingreso',
		'$#monto_pesos'
#		'estado'
	]

	belongs_to :tar_factura, optional: true

	def padre
		self.owner_class == 'RegReporte' ? self.owner_class.constantize.find(self.owner_id).owner : self.owner_class.constantize.find(self.owner_id)
	end

	def owner
		self.owner_class.constantize.find(self.owner_id)
	end

	def pago
		unless self.padre.tar_tarifa.tar_pagos.empty?
			self.padre.tar_tarifa.tar_pagos.find_by(codigo_formula: self.facturable)
		else
			nil
		end
	end

	def monto_ingreso
		self.monto.blank? ? 0 : self.monto
	end

	# métodos para la correcto uso de la UF

	def fecha_uf
		self.tar_factura.blank? ? DateTime.now.in_time_zone('Santiago') : self.tar_factura.fecha
	end

	def to_pesos
		uf = TarUfSistema.find_by(fecha: self.fecha_uf.to_date)
		uf.blank? ? 0 : (self.monto_ingreso.to_d.truncate(2) * uf.valor)
	end	

	def to_uf
		uf = TarUfSistema.find_by(fecha: self.fecha_uf.to_date)
		uf.blank? ? 0 : (self.monto_ingreso.to_d.truncate(0) / uf.valor)
	end

	def monto_pesos
		self.moneda == 'Pesos' ? self.monto_ingreso : self.to_pesos
	end

	def monto_uf
		self.moneda == 'Pesos' ? self.to_uf : self.monto_ingreso
	end

end
