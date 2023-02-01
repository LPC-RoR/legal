class TipoCausa < ApplicationRecord

	TABLA_FIELDS = 	[
		'tipo_causa'
	]

	has_many :causas

end
