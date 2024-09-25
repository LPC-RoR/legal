class AppPerfil < ApplicationRecord

	belongs_to :app_nomina

	has_many :app_mensajes

	has_many :blg_articulos

	# Aplicacion
	# Si cfg_defaults[:activa_tipos_usuario] = true
	has_one :age_usuario

	def self.dog
		AppNomina.dog.app_perfil
	end

	def dog?
		self.app_nomina.dog?
	end

	def app_enlaces
		AppEnlace.where(owner_class: 'AppPerfil', owner_id: self.id)
	end

	def nombre
		self.email == AppVersion::DOG_EMAIL ? AppVersion::DOG_NAME : AppNomina.find_by(email: self.email).nombre
	end

end
