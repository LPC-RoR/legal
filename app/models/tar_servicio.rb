class TarServicio < ApplicationRecord

	TIPOS = ['único', 'mensual', 'horas']

	MONEDAS = ['pesos', 'uf']

	TABLA_FIELDS = [
		['codigo',      'normal'],
		['descripcion', 'show'],
		['tipo',        'normal'],
		['moneda',      'normal'],
		['monto',       'valor'],
		['estado',      'normal']
	]

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end

	def cliente
		self.padre
	end

	def facturaciones
		TarFacturacion.where(owner_class: 'TarServicio', owner_id: self.id)
	end

end
