class TarComentario < ApplicationRecord

	TABLA_FIELDS = [
		'orden',
		'tipo',
		'formula'
	]

	belongs_to :tar_pago

end
