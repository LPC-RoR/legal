class AppNomina < ApplicationRecord

	TIPOS = ['operación', 'finanzas', 'general', 'admin']

	belongs_to :ownr, polymorphic: true, optional: true

	has_one :app_perfil

	validates :nombre, :email, presence: true
	validates :nombre, :email, uniqueness: true

	scope :gnrl, -> { where(ownr_id: nil)}

	scope :nombre_ordr, -> { order(:nombre) }

	def self.dog
		find_by(email: AppVersion::DOG_EMAIL)		
	end

	def self.activa(usuario)
		find_by(email: usuario.email)
	end

	def dog?
		self.ownr_type == 'AppVersion'
	end

	def dominio
		self.ownr.class.name
	end

	# DEPRECATED Antiguo 'perfil'
	def perfil2
		perfil = AppPerfil.find_by(email: self.email)
	end

end