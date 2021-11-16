class Causa < ApplicationRecord
	TABLA_FIELDS = 	[
		['causa', 'show']
	]

	belongs_to :cliente
end
