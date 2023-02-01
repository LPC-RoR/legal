class StEstado < ApplicationRecord

	TABLA_FIELDS = [
		'orden',
		'st_estado'
	]

	belongs_to :st_modelo
end
