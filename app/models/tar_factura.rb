class TarFactura < ApplicationRecord
	# Tabla de FACTURAS de VENTA
	# Tiene tar_facturaciones

	TABLA_FIELDS = [
		'documento',
		's#d_concepto',
		'padre:razon_social',
		'fecha_factura'
	]

	has_many :tar_facturaciones

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end

	def monto_pesos
		unless self.uf.blank?
			self.tar_facturaciones.map {|facturacion| facturacion.moneda == 'Pesos' ? facturacion.monto_ingreso : (facturacion.monto_ingreso * self.uf)}.compact.sum
		else
			0
		end
	end

	def monto_uf
		unless self.uf.blank?
			self.tar_facturaciones.map {|facturacion| facturacion.moneda == 'Pesos' ? (facturacion.monto_ingreso/self.uf) : (facturacion.monto_ingreso)}.compact.sum
		else
			0
		end
	end

	def fecha
		self.estado == 'ingreso' ? DateTime.now.in_time_zone('Santiago') : (self.fecha_uf.blank? ? self.fecha_factura : self.fecha_uf)
	end

	def uf
		TarUfSistema.find_by(fecha: self.fecha.to_date).valor
	end

	def d_concepto
		self.concepto.blank? ? 'concepto no ingresado' : self.concepto
	end

end
