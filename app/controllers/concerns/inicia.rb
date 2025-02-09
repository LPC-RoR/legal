module Inicia
	extend ActiveSupport::Concern

	# @concern.seguridad.rb : version_activa?, dog_email

	def init_vrsn
		# Cada una está con una condición distinta por si la transacción se quiebra
		vrs = AppVersion.create(dog_email: dog_email) unless version_activa?
		vrs.app_nomina = AppNomina.create(nombre: Rails.application.credentials[:dog][:name], email: Rails.application.credentials[:dog][:email]) if AppNomina.dog.blank?
	end

	def inicia_sesion

		if usuario_signed_in?

			init_vrsn								# Verifica existencia de versión y nómina de DOG
	
			unless perfil_activo?					# # USUARIO SIN PERFIL (Primer ingreso)

				if nomina_activa?
					nomina_activa.app_perfil = AppPerfil.create(email: current_usuario.email)
				elsif libre_registro?
					# Hay que ver si la aplicación está preparada para funcionar 
					# con usuarios registrados que no pertenezcan a una nómina
				else
					sign_out_and_redirect(current_usuario)
				end

			end
		end

		# si hay perfil_activo ? hay usuarios se inicia applicacion : se despliega home SIN perfil_activo
		inicia_app if perfil_activo?

	end

end