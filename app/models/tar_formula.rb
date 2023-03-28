class TarFormula < ApplicationRecord

	TABLA_FIELDS = [
		'orden',
		'codigo',
		'tar_formula'
	]

	belongs_to :tar_tarifa

    validates_presence_of :orden, :tar_formula
end
