class AppAdministrador < ApplicationRecord

	TABLA_FIELDS = [
		'administrador', 
		'email',
		'perfil'
	]

	has_one :app_perfil

	validates :administrador, :email, presence: true
	validates :administrador, :email, uniqueness: true

	scope :ordered, -> { order(:app_administrador) }

	def perfil
		perfil = AppPerfil.find_by(email: self.email)
		perfil.blank? ? 'Sin perfil' : 'Perfil activo'
	end

end
