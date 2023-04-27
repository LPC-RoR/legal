class Juzgado < ApplicationRecord

	TABLA_FIELDS = 	[
		'juzgado'
	]

	has_many :causas
end
