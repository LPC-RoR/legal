class AppPerfil < ApplicationRecord

	TABLA_FIELDS = [
		'email'
	]


	belongs_to :app_administrador, optional: true

	has_many :app_observaciones
	has_many :app_mejoras
	has_many :app_mensajes

	has_many :contacto_personas
	has_many :contacto_empresas

	def app_enlaces
		AppEnlace.where(owner_class: 'AppPerfil', owner_id: self.id)
	end

end
