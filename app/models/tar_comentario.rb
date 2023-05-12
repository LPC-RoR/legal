class TarComentario < ApplicationRecord

	TABLA_FIELDS = [
		'orden',
		'tipo',
		'formula',
		'despliegue'
	]

	belongs_to :tar_pago

end
