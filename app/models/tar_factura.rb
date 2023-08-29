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

	# DEPRECATED : se reemplaza con owner
	def padre
		self.owner_class.constantize.find(self.owner_id)
	end

	def owner
		self.owner_class.constantize.find(self.owner_id)
	end

	def monto_pesos
		self.tar_facturaciones.map {|facturacion| facturacion.monto_pesos}.compact.sum
	end

	def monto_uf
		self.tar_facturaciones.map {|facturacion| facturacion.monto_uf}.compact.sum
	end

	def fecha
		self.fecha_uf.blank? ? self.fecha_factura : self.fecha_uf
	end

	def d_concepto
		self.concepto.blank? ? 'concepto no ingresado' : self.concepto
	end

end
