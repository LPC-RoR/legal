class AppPerfil < ApplicationRecord

	TABLA_FIELDS = [
		'email'
	]

	has_many :app_observaciones
	has_many :app_mejoras
	has_many :app_mensajes

	def app_enlaces
		AppEnlace.where(owner_class: 'AppPerfil', owner_id: self.id)
	end

	def administrador?
		AppAdministrador.find_by(email: self.email).present?
	end

	def repositorio
		AppRepo.where(owner_class: self.class.name).find_by(owner_id: self.id)
	end

end
