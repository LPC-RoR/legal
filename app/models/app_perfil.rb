class AppPerfil < ApplicationRecord

	belongs_to :app_nomina

	has_many :app_mensajes

	# Aplicacion
	# Si cfg_defaults[:activa_tipos_usuario] = true
	has_one :age_usuario

	delegate :nombre, :dominio, to: :app_nomina, prefix: true

	def self.dog
		AppNomina.dog.app_perfil
	end

	def dog?
		self.app_nomina.dog?
	end

	def nombre_agenda
		self.app_nomina_nombre.split(' ')[0]
	end

	def app_enlaces
		AppEnlace.where(owner_class: 'AppPerfil', owner_id: self.id)
	end

end
