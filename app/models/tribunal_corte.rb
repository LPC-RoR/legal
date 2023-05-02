class TribunalCorte < ApplicationRecord
	TABLA_FIELDS = 	[
		'tribunal_corte'
	]

	has_many :causas

end
