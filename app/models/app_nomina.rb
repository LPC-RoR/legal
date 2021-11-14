class AppNomina < ApplicationRecord

	TABLA_FIELDS = [
		['nombre', 'normal'],
		['email',  'show']
	]

	has_many :st_perfil_modelos

	validates :email, presence: true
	validates :email, uniqueness: true

end
