module IniciaAplicacion
	extend ActiveSupport::Concern

	def libre_registro?
		false
	end

	def inicia_app
		# Crea perfil_activo por defecto usando el correo electrónico.
		AgeUsuario.create(age_usuario: perfil_activo.email, app_perfil_id: perfil_activo.id) if perfil_activo.age_usuario.blank?
	end

end