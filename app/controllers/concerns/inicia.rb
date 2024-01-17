module Inicia
	extend ActiveSupport::Concern

	def verifica_version
		AppVersion.create(dog_email: AppVersion::DOG_EMAIL) if version_activa.blank?
	end

	def inicia_sesion

		verifica_version

		# se hace para no llamar a cada rato a la base de datos
		perfil = perfil_activo

		# si hay USUARIO AUTENTICADO pero el usuario NO TIENE PERFIL}
		# ocurre si es el primer acceso a la aplicación o si el usuario recién se creo
		if usuario_signed_in? and perfil.blank?

			# crea perfil si está en archivo de administradores o en nómina o aplicación es de libre registro
			administrador = AppAdministrador.find_by(email: current_usuario.email)
			nomina = AppNomina.find_by(email: current_usuario.email)

			if current_usuario.email == dog_email or nomina.present? or administrador.present? or libre_registro?
				perfil = AppPerfil.create(email: current_usuario.email)
			end

		end

		# si hay perfil_activo ? hay usuarios se inicia applicacion : se despliega home SIN perfil_activo
		inicia_app if perfil.present?

	end

end