class TarFactura < ApplicationRecord
	# Tabla de FACTURAS de VENTA
	# Tiene tar_facturaciones

	TABLA_FIELDS = [
		['concepto', 'show'],
		['documento',   'normal'],
		['created_at',  'normal']
	]

	has_many :tar_facturaciones

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end

end
