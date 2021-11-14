class AppAdministrador < ApplicationRecord

	TABLA_FIELDS = [
		['administrador', 'normal'], 
		['email',         'normal']
	]

	has_one :app_perfil

	validates :administrador, :email, presence: true
	validates :administrador, :email, uniqueness: true

end
