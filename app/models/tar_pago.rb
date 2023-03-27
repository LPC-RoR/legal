class TarPago < ApplicationRecord

	TABLA_FIELDS = [
		'orden',
		's#tar_pago',
#		'estado',
	]

	belongs_to :tar_tarifa

	has_many :tar_formulas
	has_many :tar_comentarios

    validates_presence_of :orden, :tar_pago

end
