class Cliente < ApplicationRecord
	TABLA_FIELDS = 	[
		['razon_social', 'show']
	]

	has_many :causas
end
