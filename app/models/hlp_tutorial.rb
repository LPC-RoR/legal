class HlpTutorial < ApplicationRecord

	TABLA_FIELDS = [
		['tutorial', 'show'],
		['clave',    'normal']
	]

	has_many :hlp_pasos

	validates :tutorial, :detalle, presence: true

end
