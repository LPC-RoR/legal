module Seguridad
	extend ActiveSupport::Concern

	# Usuario : Se dedica a autenticar usuarios exclusivamente
	# AppNomina : Se usa para registrar usuarios autorizados de distinta naturaleza. Dog, Usuarios de la aplicación Usuarios de Empresa
	# AppPerfil : Es el único activo en la aplicación, el que se usa para validar

	# ------------------------------------------------------------------- PARA USUARIOS ANÓNIMOS

	def get_version_activa
		AppVersion.activa
	end

	# No está como helper_method
	# Si no hay usuario activo, no hay nómina, luego tampoco perfil = no accede a páginas no publicas
	def get_nomina_activa
		usuario_signed_in? ? AppNomina.activa(current_usuario) : nil
	end

	def get_public_controllers
		['publicos']
	end

	def get_app_sigla
		version = get_version_activa
		version.blank? ? 'app' : (version.app_sigla.blank? ? 'app' : version.app_sigla )
	end

	def get_perfil_activo
		nomina = get_nomina_activa
		nomina.blank? ? nil : nomina.app_perfil
	end

	# ------------------------------------------------------------------- SCRTY_ON

	# Carga de objetos de seguridad
	def load_scrty_objts
		version = get_version_activa									# 'nil' si No hay versión
		dog_nomina = version.blank? ? nil : version.app_nomina			# variable de tránsito
		dog_perfil = dog_nomina.blank? ? nil : dog_nomina.app_perfil 	# 'nil' heredado o verificado
		nomina = get_nomina_activa										# 'nil' si usuario es anónimo o sin Nómina
		perfil = nomina.blank? ? nil : nomina.app_perfil				# 'nil' si nomina es nil o si sin Perfil
		usuario_agenda = perfil.blank? ? nil : perfil.age_usuario		# 
		{
			version: version,
			dog_perfil: dog_perfil,
			nomina: nomina,
			perfil: perfil,
			usuario_agenda: usuario_agenda
		}
	end

	def scrty_vls
		version = get_version_activa
		dog_email = version.blank? ? AppVersion::DOG_EMAIL : version.dog_email
		dog_name = AppVersion::DOG_NAME
		app_sigla = version.blank? ? 'app' : (version.app_sigla.blank? ? 'app' : version.app_sigla )
		public_controllers = get_public_controllers
		activa_tipos_usuario = cfg_defaults[:activa_tipos_usuario]
		{
			app_sigla: app_sigla,
			dog_email: dog_email,
			dog_name: dog_name,
			public_controllers: public_controllers,
			activa_tipos_usuario: activa_tipos_usuario			# Se usa para obtener tipo_usuario
		}
	end

	# Se llama en cada controlador para cargar las variables sólo una vez
	def scrty_on
		@scrty_objts = load_scrty_objts
		@scrty_vls = scrty_vls
	end

	# ------------------------------------------------------------------- VLS

	def dog_name
		@scrty_vls[:dog_name]
	end

	def dog_email
		@scrty_vls[:dog_email]
	end

	def app_sigla
		@scrty_vls[:app_sigla]
	end

	def public_controllers
		@scrty_vls[:public_controllers]
	end

	# Al parecer no es necesario, sólo se usa en publico? (abajo).	
	def public_controller?
		public_controllers.include?(controller_name) or controller_name.match(/^blg_*/)		
	end

	def tipo_usuario
		# Este método sólo tiene sentido si perfil_activo?
		@scrty_vls[:activa_tipos_usuario] ? (perfil_activo? ? nomina_activa.tipo : 'nil') : 'no-activado'
	end

	# ------------------------------------------------------------------- ACTIVOS

	def version_activa
		@scrty_objts[:version]
	end

	def version_activa?
		@scrty_objts[:version].present?
	end

	def dog_perfil
		@scrty_objts[:dog_perfil]
	end

	def dog_perfil?
		@scrty_objts[:dog_perfil].present?
	end

	def nomina_activa
		@scrty_objts[:nomina]
	end

	def nomina_activa?
		@scrty_objts[:nomina].present?
	end

	def perfil_activo
		@scrty_objts[:perfil]
	end

	def perfil_activo?
		@scrty_objts[:perfil].present?
	end

	def usuario_agenda
		@scrty_objts[:usuario_agenda]
	end

	def usuario_agenda?
		@scrty_objts[:usuario_agenda].present?
	end

	# ------------------------------------------------------------------- SCRTY

	# Verdadero SOLO para DOG
	def dog?
		perfil_activo == dog_perfil
	end

	# es verdadero para ADMIN y DOG
	def admin?
		( perfil_activo? and tipo_usuario == 'admin' ) or dog?
	end

	# es verdadero para OPERACIÓN, ADMIN y DOG
	def operacion?
		( perfil_activo? and tipo_usuario == 'operación' ) or admin?	# admin? considera a dog?, no es necesario ponerlo
	end

	# es verdadero para FINANZAS, ADMIN y DOG
	def finanzas?
		( perfil_activo? and tipo_usuario == 'finanzas' ) or admin?		# admin? considera a dog?, no es necesario ponerlo
	end

	# es verdadero para OPERACIÓN, FINANZAS, ADMIN y DOG
	def general?
		operacion? or finanzas?
	end

	# Al parecer no es necesario, porque lo que no se restringe, siempre es público.	
	def publico?
		action_name == 'home' ? ( not usuario_signed_in?) : public_controller?
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
			when 'usuario'			# Idem que publico?
				perfil_activo?
			else
				true
			end
		end
	end

	# ***************************************************** MANEJO DE TIPOS DE USUARIO

	def itm_scrty(item)
		item.class.name == 'Array' ? item[1] : true
	end

	#DEPRECATED : Revisar si siempre se puede reemplazar por itm_scrty
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