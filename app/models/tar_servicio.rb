class TarServicio < ApplicationRecord

	TIPOS = ['único', 'mensual']

	MONEDAS = ['Pesos', 'UF']

	TABLA_FIELDS = [
		'codigo',
		's#descripcion',
		'tipo',
		'm#monto',
		'estado'
	]

    validates_presence_of :codigo, :descripcion, :tipo, :moneda, :monto

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
