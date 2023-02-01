class TarFacturacion < ApplicationRecord

	TABLA_FIELDS = [
		'glosa',
		'uf#monto_uf',
		'$#monto',
		'estado'
	]

	belongs_to :tar_factura, optional: true

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end

end
