class TarUfFacturacion < ApplicationRecord

	TABLA_FIELDS = [
		'pago',
		'fecha_uf',
	]

	def owner
		self.owner_class.constantize.find(self.owner_id)
	end

end
