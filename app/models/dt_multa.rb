class DtMulta < ApplicationRecord
	belongs_to :dt_infraccion

	TABLA_FIELDS = 	[
		'tamanio',
		'leve',
		'grave',
		'gravisima'
	]

end
