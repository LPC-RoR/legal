module Inicia
	extend ActiveSupport::Concern

	def dog_wanted
		dog_forgoted = AppPerfil.find_by(email: dog_email)
		if dog_forgoted.blank?
			AppPerfil.create(o_clss: 'AppVersion', o_id: version_activa.id, email: dog_email)
		else
			dog_forgoted.o_clss = 'AppVersion'
			dog_forgoted.o_id = version_activa.id
			dog_forgoted.save
		end
	end

	def inicia_sesion

		# Verifica registros BASE
		AppVersion.create(dog_email: dog_email) if version_activa.blank?
		dog_wanted if version_activa.dog_perfil.blank?

		# si hay USUARIO AUTENTICADO pero el usuario NO TIENE PERFIL}
		# ocurre si es el primer acceso a la aplicación o si el usuario recién se creo
		if usuario_signed_in? and perfil_activo.blank?

			if nomina_activa.present? or libre_registro?
				AppPerfil.create(email: current_usuario.email)
			end

		end

		# si hay perfil_activo ? hay usuarios se inicia applicacion : se despliega home SIN perfil_activo
		inicia_app if perfil_activo?

	end

end