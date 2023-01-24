class TipoCausa < ApplicationRecord

	TABLA_FIELDS = 	[
		['tipo_causa', 'normal']
	]

	has_many :causas

end
