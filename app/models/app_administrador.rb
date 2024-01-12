class AppAdministrador < ApplicationRecord

	has_one :app_perfil

	validates :administrador, :email, presence: true
	validates :administrador, :email, uniqueness: true

	scope :ordered, -> { order(:app_administrador) }

	def perfil
		perfil = AppPerfil.find_by(email: self.email)
	end

end
