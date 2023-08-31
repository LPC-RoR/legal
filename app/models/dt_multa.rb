class DtMulta < ApplicationRecord
	belongs_to :dt_tabla_multa

	TABLA_FIELDS = 	[
		'tamanio',
		'leve',
		'grave',
		'gravisima'
	]

end
