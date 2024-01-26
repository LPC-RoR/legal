class TarValorCuantia < ApplicationRecord

	MONEDAS = ['Pesos', 'UF']

	belongs_to :tar_detalle_cuantia

    validates_presence_of :moneda

 	def owner
		self.owner_class.constantize.find(self.owner_id)
	end

	def detalle
		self.tar_detalle_cuantia.tar_detalle_cuantia == 'Otro' ? self.otro_detalle : self.tar_detalle_cuantia.tar_detalle_cuantia
	end

end
