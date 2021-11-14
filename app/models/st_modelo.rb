class StModelo < ApplicationRecord
	TABLA_FIELDS = [
		['st_modelo', 'show']
	]

	has_many :st_estados
end
