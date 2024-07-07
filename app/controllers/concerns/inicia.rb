module Inicia
	extend ActiveSupport::Concern

	# @concern.seguridad.rb : version_activa, dog_email

	def crea_primera_version
		AppVersion.create(dog_email: dog_email)
	end

	def get_dog
		# No se usa dog_perfil? porque dog_perfil.blank? considera que exista pero no esté ligado a version_activa
		dog_prfl = dog_perfil.blank? ? AppPerfil.create(o_clss: 'AppVersion', o_id: version_activa.id, email: dog_email) : dog_perfil

		dog_prfl.o_clss = 'AppVersion'
		dog_prfl.o_id = version_activa.id
		dog_prfl.save
	end

	def inicia_sesion
		# Verifica version_activa y dog_perfil
		crea_primera_version unless version_activa?
		get_dog unless dog_perfil?

		# USUARIO SIN PERFIL (Primer ingreso)
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