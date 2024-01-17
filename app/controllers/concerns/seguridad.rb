module Seguridad
	extend ActiveSupport::Concern

	def version_activa
		AppVersion.last
	end

	def dog_name
		AppVersion::DOG_NAME
	end

	def dog_email
		AppVersion::DOG_EMAIL
	end

	def perfil?
		usuario_signed_in? ? AppPerfil.find_by(email: current_usuario.email).present? : false
	end

	def perfil_activo
		usuario_signed_in? ? AppPerfil.find_by(email: current_usuario.email) : nil
	end

	def perfil_activo_id
		perfil_activo.blank? ? nil : perfil_activo.id
	end

	# HASTA AQUI REVISADO

	def dog?
		usuario_signed_in? ? (current_usuario.email == dog_email) : false
	end

	def admin?
		usuario_signed_in? ? AppAdministrador.find_by(email: current_usuario.email).present? : false
	end

	def nomina?
		usuario_signed_in? ? AppNomina.find_by(email: current_usuario.email).present? : false
	end

	def general?
		usuario_signed_in? and not admin? and not nomina?
	end

	def anonimo?
		not usuario_signed_in?
	end

	def publico?
		action_name == 'home' ? ( not usuario_signed_in?) : (['publicos'].include?(controller_name) or controller_name.match(/^blg_*/))
	end

	def mi_seguridad?
		if current_usuario.email == dog_email
			:dog
		elsif AppAdministrador.find_by(email: current_usuario.email).present?
			:admin
		elsif AppNomina.find_by(email: current_usuario.email).present?
			:nomina
		elsif usuario_signed_in?
			:general
		else
			:anonimo
		end
	end

	def seguridad_desde(tipo_usuario)
		if tipo_usuario.blank?
			dog? or admin?
		else
			case tipo_usuario
			when 'dog'
				dog?
			when 'admin'
				dog? or admin?
			when 'nomina'
				dog? or admin? or nomina?
			when 'general'
				dog? or admin? or nomina? or general?
			when 'anonimo'
				true
			end
		end
	end

end