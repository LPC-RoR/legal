class StEstado < ApplicationRecord

	TABLA_FIELDS = [
		['orden',     'normal'],
		['st_estado', 'normal']
	]

	belongs_to :st_modelo
end
