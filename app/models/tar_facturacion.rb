class TarFacturacion < ApplicationRecord

	TABLA_FIELDS = [
		['glosa', 'normal'],
		['monto',      'pesos'],
		['estado',     'normal']
	]

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end

end
