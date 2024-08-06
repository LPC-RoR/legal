class AppNomina < ApplicationRecord

	has_many :pro_nominas
	has_many :productos, through: :pro_nominas

	validates :nombre, :email, presence: true
	validates :nombre, :email, uniqueness: true

	scope :ordered, -> { order(:nombre) }

	def perfil
		perfil = AppPerfil.find_by(email: self.email)
	end

end
