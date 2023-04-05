class TarFacturacion < ApplicationRecord

	TABLA_FIELDS = [
		'glosa',
		'm#monto',
		'estado'
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

end
