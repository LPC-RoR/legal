class TarFactura < ApplicationRecord
	# Tabla de FACTURAS de VENTA
	# Tiene tar_facturaciones

	TABLA_FIELDS = [
		'documento',
		's#d_concepto',
		'created_at'
	]

	has_many :tar_facturaciones

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end

	def monto_pesos
		unless self.uf.blank?
			self.tar_facturaciones.map {|facturacion| facturacion.moneda == 'Pesos' ? facturacion.monto : (facturacion.monto * self.uf)}.sum
		else
			0
		end
	end

	def monto_uf
		unless self.uf.blank?
			self.tar_facturaciones.map {|facturacion| facturacion.moneda == 'Pesos' ? (facturacion.monto/self.uf) : (facturacion.monto)}.sum
		else
			0
		end
	end

	def fecha
		self.fecha_uf.blank? ? DateTime.now.to_date : self.fecha_uf
	end

	def uf
		self.fecha_uf.blank? ? (TarUfSistema.find_by(fecha: DateTime.now.to_date).blank? ? nil : TarUfSistema.find_by(fecha: DateTime.now.to_date).valor) : (TarUfSistema.find_by(fecha: self.fecha_uf.to_date).blank? ? nil : TarUfSistema.find_by(fecha: self.fecha_uf.to_date).valor)
	end

	def d_concepto
		self.concepto.blank? ? 'concepto no ingresado' : self.concepto
	end

end
