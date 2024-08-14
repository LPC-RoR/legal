module IniciaAplicacion
	extend ActiveSupport::Concern

	def libre_registro?
		false
	end

	def inicia_app
		puts "************************************************************ inicia_app"
		puts usuario_agenda?
		puts nombre_agenda
		puts perfil_activo.id
		# Crea perfil_activo por defecto usando el primer nombre.
		AgeUsuario.create(age_usuario: nombre_agenda, app_perfil_id: perfil_activo.id) unless usuario_agenda?
	end

end