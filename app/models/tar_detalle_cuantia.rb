class TarDetalleCuantia < ApplicationRecord

	TABLA_FIELDS = [
		'tar_detalle_cuantia',
		'descripcion'
	]

	has_many :tar_valor_cuantias

    validates_presence_of :tar_detalle_cuantia

end
