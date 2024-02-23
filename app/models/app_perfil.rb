class AppPerfil < ApplicationRecord

	has_many :app_observaciones
	has_many :app_mejoras
	has_many :app_mensajes

	has_many :blg_articulos

	has_many :age_usuarios

	# Revisar DEPRECATED
	has_many :age_act_perfiles
	has_many :age_actividades, through: :age_act_perfiles

	def nombre_perfil
		self.email == AppVersion::DOG_EMAIL ? AppVersion::DOG_NAME : AppNomina.find_by(email: self.email).nombre
	end

	def app_enlaces
		AppEnlace.where(owner_class: 'AppPerfil', owner_id: self.id)
	end

	# DEPRECATED Revisar
	def repositorio
		AppRepositorio.where(owner_class: self.class.name).find_by(owner_id: self.id)
	end

	# DEPRECATED Revisar
	def modelo_perfil
		MModelo.find_by(ownr_class: self.class.name, ownr_id: self.id)
	end

end
