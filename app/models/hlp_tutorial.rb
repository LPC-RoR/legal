class HlpTutorial < ApplicationRecord

	TABLA_FIELDS = [
		's#tutorial',
		'clave'
	]

	has_many :hlp_pasos

	validates :tutorial, :detalle, presence: true

end
