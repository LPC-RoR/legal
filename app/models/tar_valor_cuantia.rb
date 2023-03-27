class TarValorCuantia < ApplicationRecord

	MONEDAS = ['Pesos', 'UF']

	TABLA_FIELDS = [
		'detalle',
		'm#valor'
	]

	belongs_to :tar_detalle_cuantia

    validates_presence_of :moneda, :valor

 	def owner
		self.owner_class.constantize.find(self.owner_id)
	end

	def detalle
		self.tar_detalle_cuantia.tar_detalle_cuantia
	end

end
