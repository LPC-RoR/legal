module Inicia
	extend ActiveSupport::Concern

	# @concern.seguridad.rb : version_activa, dog_email

	def init_vrsn
		# Cada una está con una condición distinta por si la trransacción se quiebra
		vrs = AppVersion.create(dog_email: dog_email) unless version_activa?
		vrs.app_nomina = AppNomina.create(nombre: AppVersion::DOG_NAME, email: AppVersion::DOG_EMAIL) if AppNomina.dog.blank?
	end

	def inicia_sesion

		if usuario_signed_in?

			init_vrsn								# Verifica existencia de versión y nómina de DOG
	
			if perfil_activo.blank?					# # USUARIO SIN PERFIL (Primer ingreso)

				if nomina_activa.present? or libre_registro?
					nomina_activa.app_perfil = AppPerfil.create(email: current_usuario.email)
				else
					sign_out_and_redirect(current_usuario)
				end

			end
		end

		# si hay perfil_activo ? hay usuarios se inicia applicacion : se despliega home SIN perfil_activo
		inicia_app if perfil_activo?

	end

end