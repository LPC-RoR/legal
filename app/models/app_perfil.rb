class AppPerfil < ApplicationRecord

	TABLA_FIELDS = [
		'email'
	]

	has_many :app_observaciones
	has_many :app_mejoras
	has_many :app_mensajes

#	has_many :app_actividades

	has_many :blg_articulos

	has_many :age_act_perfiles
	has_many :age_actividades, through: :age_act_perfiles

	def nombre_perfil
		administrador = AppAdministrador.find_by(email: self.email)
		if administrador.blank?
			nomina = AppNomina.find_by(email: self.email)
			nomina.blank? ? 'no encontrado' : nomina.nombre
		else
			administrador.administrador
		end
	end

	def app_enlaces
		AppEnlace.where(owner_class: 'AppPerfil', owner_id: self.id)
	end

	def administrador?
		AppAdministrador.find_by(email: self.email).present?
	end

	def repositorio
		AppRepositorio.where(owner_class: self.class.name).find_by(owner_id: self.id)
	end

	def modelo_perfil
		MModelo.find_by(ownr_class: self.class.name, ownr_id: self.id)
	end

end
