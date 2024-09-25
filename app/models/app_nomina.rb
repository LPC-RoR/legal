class AppNomina < ApplicationRecord

	belongs_to :ownr, polymorphic: true, optional: true

	has_one :app_perfil

	has_many :pro_nominas
	has_many :productos, through: :pro_nominas

	validates :nombre, :email, presence: true
	validates :nombre, :email, uniqueness: true

	scope :gnrl, -> { where(ownr_type: nil)}

	scope :ordered, -> { order(:nombre) }

	def self.dog
		find_by(email: AppVersion::DOG_EMAIL)		
	end

	def dog?
		self.ownr_type == 'AppVersion'
	end

	def perfil
		perfil = AppPerfil.find_by(email: self.email)
	end

end