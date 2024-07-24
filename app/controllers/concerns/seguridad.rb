module Seguridad
	extend ActiveSupport::Concern

	# SCRTY_ON

	def rcrds_ctvs 
		perfil = get_perfil_activo
		{
			version: get_version_activa,
			nomina: usuario_signed_in? ? AppNomina.find_by(email: current_usuario.email) : nil,
			perfil: perfil,
			dog_perfil: AppPerfil.find_by(email: AppVersion::DOG_EMAIL),
			usuario_agenda: usuario_signed_in? ? perfil.age_usuario : nil
		}
	end

	def scrty_vls
		{
			dog_name: AppVersion::DOG_NAME,
			dog_email: AppVersion::DOG_EMAIL,
			public_controllers: get_public_controllers,
			activa_tipos_usuario: cfg_defaults[:activa_tipos_usuario]
		}
	end

	def scrty_on
		@rcrds_ctvs = rcrds_ctvs
		@scrty_vls = scrty_vls
	end

	# VLS

	def get_public_controllers
		['publicos']
	end

	def public_controllers
		@scrty_vls[:public_controllers]
	end

	def dog_name
		usuario_signed_in? ? @scrty_vls[:dog_name] : get_version_activa.dog_name
	end

	def dog_email
		usuario_signed_in? ? @scrty_vls[:dog_email] : get_version_activa.dog_email
	end

	# ACTIVOS

	def dog_perfil
		@rcrds_ctvs[:dog_perfil]
	end

	def dog_perfil?
		dog_perfil.present? and dog_perfil.o_clss == 'AppVersion' and dog_perfil.o_id == version_activa.id
	end

	def usuario_agenda
		@rcrds_ctvs[:usuario_agenda]
	end

	def usuario_agenda?
		usuario_signed_in? ? usuario_agenda.present? : false
	end

	def get_version_activa
		AppVersion.last
	end

	def version_activa
		@rcrds_ctvs[:version]
	end

	def version_activa?
		usuario_signed_in? ? version_activa.present? : false
	end

	def nomina_activa
		@rcrds_ctvs[:nomina]
	end

	def nomina_activa?
		usuario_signed_in? ? nomina_activa.present? : false
	end

	def get_perfil_activo
		usuario_signed_in? ? AppPerfil.find_by(email: current_usuario.email) : nil
	end

	def perfil_activo
		@rcrds_ctvs[:perfil]
	end

	def perfil_activo?
		usuario_signed_in? ? perfil_activo.present? : false
	end

	def usuario_activo?
		usuario_signed_in? ? (nomina_activa.present? or dog?) : false
	end

	def nombre_perfil
		dog? ? dog_name : ( nomina_activa? ? '' : nomina_activa.nombre)
	end

	def nombre_agenda
		 nombre_perfil == '' ? '' : nombre_perfil.split(' ')[0]
	end

	# SCRTY

	def tipo_usuario
		scrty_vls[:activa_tipos_usuario] ? (nomina_activa.present? ? nomina_activa.tipo : nil) : 'general'
	end

	# Verdadero SOLO para DOG
	def dog?
		# Se usa el usuario porque dog no requiere nómina para funcionar
		usuario_signed_in? ? (current_usuario.email == dog_email) : false
	end

	# es verdadero para ADMIN y DOG
	def admin?
		( usuario_activo? and tipo_usuario == 'admin' ) or dog?
	end

	# es verdadero para OPERACIÓN, ADMIN y DOG
	def operacion?
		( usuario_activo? and tipo_usuario == 'operación' ) or admin? or dog?
	end

	# es verdadero para FINANZAS, ADMIN y DOG
	def finanzas?
		( usuario_activo? and tipo_usuario == 'finanzas' ) or admin? or dog?
	end

	# es verdadero para OPERACIÓN, FINANZAS, ADMIN y DOG
	def general?
		operacion? or finanzas?
	end

	def public_controllers?
		public_controllers.include?(controller_name) or controller_name.match(/^blg_*/)		
	end

	# Al parecer no es necesario, porque lo que no se restringe, siempre es público.	
	def publico?
		action_name == 'home' ? ( not usuario_signed_in?) : public_controllers?
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
			when 'general'
				general?
			when 'finanzas'
				finanzas?
			when 'operación'
				operacion?
			when 'usuario'
				usuario_activo?
			when 'nomina' # DEPRECATED
				admin? or nomina_activa?
			when 'excluir' # DEPRECATED
				false
			else
				true
			end
		end
	end

	# ***************************************************** MANEJO DE TIPOS DE USUARIO

	# Se usa en LMENU
	def lm_seguridad(modelo)
		modelo.class.name == 'Array' ? seguridad(modelo[1]) : true
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