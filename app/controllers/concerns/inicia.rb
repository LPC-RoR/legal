module Inicia
	extend ActiveSupport::Concern

	def verifica_version
		AppVersion.create(dog_email: AppVersion::DOG_EMAIL) if version_activa.blank?

		limpia_perfil = AppPerfil.where(email: dog_email, o_id: nil).first
		limpia_perfil.delete unless limpia_perfil.blank?

		dog_perfil = version_activa.dog_perfil
		AppPerfil.create(o_clss: 'AppVersion', o_id: version_activa.id, email: AppVersion::DOG_EMAIL) if dog_perfil.blank?
	end

	def inicia_sesion

		# Crea AppVersión si no tiene registros y crea perfil del DOG
		verifica_version

		# si hay USUARIO AUTENTICADO pero el usuario NO TIENE PERFIL}
		# ocurre si es el primer acceso a la aplicación o si el usuario recién se creo
		if usuario_signed_in? and perfil_activo.blank?

			if nomina_activa.present? or libre_registro?
				perfil = AppPerfil.create(email: current_usuario.email)
			end

		end

		# si hay perfil_activo ? hay usuarios se inicia applicacion : se despliega home SIN perfil_activo
		inicia_app if perfil_activo?

	end

end