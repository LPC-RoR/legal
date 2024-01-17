class TarFactura < ApplicationRecord
	# Tabla de FACTURAS de VENTA
	# Tiene tar_facturaciones

	TABLA_FIELDS = [
		'documento',
		's#d_concepto',
		'padre:razon_social',
		'fecha_factura'
	]

	has_one :tar_nota_credito
	has_many :tar_facturaciones

	has_many :m_reg_facts
	has_many :m_registros, through: :m_reg_facts

	# Para respaldar archivo factura
	def factura
		AppArchivo.where(owner_class: self.class.name).find_by(owner_id: self.id)
	end

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

	def monto_corregido
		self.tar_nota_credito.blank? ? self.monto_pesos : (self.tar_nota_credito.monto_total ? 0 : self.monto_pesos - self.tar_nota_credito.monto)
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

	def pagado
		self.m_reg_facts.map {|mrf| mrf.monto}.sum
	end

	def pagada?
		self.monto_pesos == self.pagado
	end

	def disponible
		self.monto_pesos - self.pagado
	end

end
