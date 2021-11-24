class TarFacturacion < ApplicationRecord

	TABLA_FIELDS = [
		['glosa', 'normal'],
		['monto',      'pesos'],
		['estado',     'normal']
	]

	belongs_to :tar_factura, optional: true

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end

end
