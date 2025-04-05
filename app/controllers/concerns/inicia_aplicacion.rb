module IniciaAplicacion
	extend ActiveSupport::Concern

	def libre_registro?
		false
	end

	def inicia_app
		# Crea perfil_activo por defecto usando el primer nombre.
		AgeUsuario.create(age_usuario: perfil_activo.nombre_agenda, app_perfil_id: perfil_activo.id) unless usuario_agenda?

		scp = get_scp_activo
		if scp.present?
			redirect_to "/cuentas/#{scp.id}/#{scp.class.name.downcase[0]}cta"
		end
	end

end