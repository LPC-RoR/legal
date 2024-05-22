module Inicia
	extend ActiveSupport::Concern

	# @concern.seguridad.rb : version_activa, dog_email

	def crea_primera_version
		AppVersion.create(dog_email: dog_email)
	end

	def dog_wanted
		# Si hay una versión anterio puede que dog_perfil ya exista
		# Busca el perfil de DOG
		dog_perfil = AppPerfil.find_by(email: dog_email)
		# Lo crea si no existe
		dog_perfil = AppPerfil.create(o_clss: 'AppVersion', o_id: version_activa.id, email: dog_email) if dog_perfil.blank?

		dog_perfil.o_clss = 'AppVersion'
		dog_perfil.o_id = version_activa.id
		dog_perfil.save
	end

	def inicia_sesion

		# crea Version con informaciòn mínima si no la encuentra
		crea_primera_version if version_activa.blank?
		dog_wanted if version_activa.dog_perfil.blank?

		# si hay USUARIO AUTENTICADO pero el usuario NO TIENE PERFIL}
		# ocurre si el usuario recién se creo, el perfil de DOG fue creado en dog_wanted
		if usuario_signed_in? and perfil_activo.blank?

			if nomina_activa.present? or libre_registro?
				AppPerfil.create(email: current_usuario.email)
			else
				sign_out_and_redirect(current_usuario)
			end

		end

		# si hay perfil_activo ? hay usuarios se inicia applicacion : se despliega home SIN perfil_activo
		inicia_app if perfil_activo?

	end

end