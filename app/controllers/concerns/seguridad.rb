module Seguridad
	extend ActiveSupport::Concern

	# CONFIG

	def public_controllers
		['publicos']
	end

	# METHODS

	def version_activa
		AppVersion.last
	end

	def dog_name
		AppVersion::DOG_NAME
	end

	def dog_email
		AppVersion::DOG_EMAIL
	end

	def nomina_activa
		usuario_signed_in? ? AppNomina.find_by(email: current_usuario.email) : nil
	end

	def perfil_activo?
		usuario_signed_in? ? AppPerfil.find_by(email: current_usuario.email).present? : false
	end

	def perfil_activo
		usuario_signed_in? ? AppPerfil.find_by(email: current_usuario.email) : nil
	end

	def dog?
		usuario_signed_in? ? (current_usuario.email == dog_email) : false
	end

	def admin?
		es_admin = usuario_signed_in? ? ( nomina_activa.blank? ? false : ( nomina_activa.tipo == 'admin' ) ) : false
		es_admin or dog?
	end

	def usuario?
		es_usuario = usuario_signed_in? ? ( nomina_activa.blank? ? false : ( nomina_activa.tipo != 'admin' ) ) : false
		es_usuario or dog?
	end

	# DEPRECATED : A futuro se introduce la categoría 'servicio para regular el acceso a los controladores de servicios.'
	def nomina?
		usuario_signed_in? ? AppNomina.find_by(email: current_usuario.email).present? : false
	end

	def publico?
		action_name == 'home' ? ( not usuario_signed_in?) : (public_controllers.include?(controller_name) or controller_name.match(/^blg_*/))
	end

	def seguridad(nivel)
		if nivel.blank?
			admin?
		else
			case nivel
			when 'dog'
				dog?
			when 'admin'
				admin?
			when 'usuario'
				usuario?
			when 'nomina'
				admin? or nomina?
			when 'excluir'
				false
			else
				true
			end
		end
	end

	# ***************************************************** MANEJO DE TIPOS DE USUARIO

	# Depnde de los tipos definidos en la aplicación
	# Quizá deba estar en otro lado
	def check_tipo_usuario(tipo)
		chk = [perfil_activo.tipo_usuario(cfg_defaults[:activa_tipos_usuario]), tipo].include?('general') ? true : perfil_activo.tipo_usuario(cfg_defaults[:activa_tipos_usuario]) == tipo
		chk
	end

	# Se usa en lmenu
	def lm_check_tipo_usuario(modelo)
		modelo.class.name == 'Array' ? check_tipo_usuario(modelo[1]) : true
	end

	def operacion?
		['operación', 'general', 'admin'].include?(perfil_activo.tipo_usuario(cfg_defaults[:activa_tipos_usuario]))
	end

	def finanzas?
		['finanzas', 'general', 'admin'].include?(perfil_activo.tipo_usuario(cfg_defaults[:activa_tipos_usuario]))
	end

end