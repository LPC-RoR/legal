class TarValorCuantia < ApplicationRecord

	TABLA_FIELDS = [
		'detalle',
		'uf#valor_uf',
		'$#valor'
	]

	belongs_to :tar_detalle_cuantia

	def owner
		self.owner_class.constantize.find(self.owner_id)
	end

	def detalle
		self.tar_detalle_cuantia.tar_detalle_cuantia
	end
end
