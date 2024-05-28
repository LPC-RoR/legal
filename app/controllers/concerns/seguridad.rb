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

	# es verdadero SOLO para dog
	def dog?
		# Se usa el usuario porque dog no requiere nómina para funcionar
		usuario_signed_in? ? (current_usuario.email == dog_email) : false
	end

	# es verdadero para admin y dog
	def admin?
		( usuario? and perfil_activo.tipo_usuario(cfg_defaults[:activa_tipos_usuario], nomina_activa) == 'admin' ) or dog?
		#['operación', 'finanzas', 'general', 'admin'].include?(perfil_activo.tipo_usuario(cfg_defaults[:activa_tipos_usuario], nomina_activa)) or dog?
	end

	# es verdadero para operación, admin y dog
	def operacion?
		( usuario? and perfil_activo.tipo_usuario(cfg_defaults[:activa_tipos_usuario], nomina_activa) == 'operación' ) or admin? or dog?
		#['operación', 'general', 'admin'].include?(perfil_activo.tipo_usuario(cfg_defaults[:activa_tipos_usuario], nomina_activa)) or dog?
	end

	# es verdadero para finanzas, admin y dog
	def finanzas?
		( usuario? and perfil_activo.tipo_usuario(cfg_defaults[:activa_tipos_usuario], nomina_activa) == 'finanzas' ) or admin? or dog?
		['finanzas', 'general', 'admin'].include?(perfil_activo.tipo_usuario(cfg_defaults[:activa_tipos_usuario], nomina_activa)) or dog?
	end

	# es verdadero para operación, finanzas, admin y dog
	def general?
		( usuario? and ['operación', 'finanzas'].include?(perfil_activo.tipo_usuario(cfg_defaults[:activa_tipos_usuario], nomina_activa)) ) or admin? or dog?
	end

	# es verdadero para usuario activo con ( nómina activa o dog )
	# debemos agregar dog porque, al no tener nómina no tendría acceso
	def usuario?
		usuario_signed_in? ? (nomina_activa.present? or dog?) : false
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
		case tipo
		when 'dog'
			dog?
		when 'admin'
			admin?
		when 'general'
			general?
		when 'finanzas'
			finanzas?
		when 'operación'
			operacion?
		when 'usuario'
			usuario?
		end
	end

	# Se usa en lmenu
	def lm_check_tipo_usuario(modelo)
		modelo.class.name == 'Array' ? check_tipo_usuario(modelo[1]) : true
	end

	def check_crud(objeto)
		class_name = objeto.class.name == 'String' ? objeto : objeto.class.name
		model = StModelo.find_by(st_modelo: class_name)
		model.blank? ? true : ( model.crud.blank? ? false : (model.crud == 'operación' ? operacion? : finanzas?) )
	end

	def check_k_estados(objeto)
		class_name = objeto.class.name == 'String' ? objeto : objeto.class.name
		model = StModelo.find_by(st_modelo: class_name)
		model.blank? ? true : ( model.k_estados.blank? ? false : (model.k_estados == 'operación' ? operacion? : finanzas?) )
	end

	def check_st_estado(objeto, estado)
		class_name = objeto.class.name == 'String' ? objeto : objeto.class.name
		model = StModelo.find_by(st_modelo: class_name)
		estado = model.st_estados.find_by(st_estado: estado)
		(model.blank? or estado.blank?) ? true : ( estado.check.blank? ? true : (estado.check == 'operación' ? operacion? : finanzas?) )
	end

end