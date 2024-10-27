class TribunalCorte < ApplicationRecord
	TABLA_FIELDS = 	[
		'tribunal_corte'
	]

	has_many :causas

	scope :trbnl_ordr, -> {order(:tribunal_corte)}

end
