class ApplicationController < ActionController::Base

	include IniciaAplicacion

	helper_method :dog?, :admin?, :nomina?, :general?, :anonimo?, :seguridad_desde, :dog_email, :dog_name, :perfil?, :perfil_activo, :perfil_activo_id

	def verifica_primer_acceso
		if ActiveRecord::Base.connection.table_exists? 'app_administradores'
			@dog = AppAdministrador.find_by(email: dog_email)
			@dog = AppAdministrador.create(administrador: dog_name, email: dog_email) if @dog.blank?
		else
			@dog = Administrador.find_by(email: dog_email)
			@dog = Administrador.create(administrador: dog_name, email: dog_email) if @dog.blank?
		end
	end

	def inicia_sesion

		# Proceso para migrar tablas a formato AppTbla: activar si corresponde
		# set_tablas_base if dog?

		# se hace para no llamar a cada rato a la base de datos
		perfil = perfil_activo

		# si hay USUARIO AUTENTICADO pero el usuario NO TIENE PERFIL}
		# ocurre si es el primer acceso a la aplicación o si el usuario recién se creo
		if usuario_signed_in? and perfil.blank?

			# INICIALIZA VARIBLES EN PRIMER ACCESO
			verifica_primer_acceso

			# crea perfil si está en archivo de administradores o en nómina o aplicación es de libre registro
			administrador = AppAdministrador.find_by(email: current_usuario.email)
			nomina = AppNomina.find_by(email: current_usuario.email)

			if nomina.present? or administrador.present or libre_registro?
				perfil = AppPerfil.create(email: current_usuario.email)
			end

		end

		# si hay perfil_activo ? hay usuarios se inicia applicacion : se despliega home SIN perfil_activo
		inicia_app if perfil.present?

	end

	# Este método se usa para construir un nombre de directorio a partir de un correo electrónico.
	def archivo_usuario(email, params)
		email.split('@').join('-').split('.').join('_')
	end

	# ************************************************************************** INICIALIZA TAB
	def init_tab(tabs, options_init)

		@tabs = tabs
		@options = {} if options_init

	    @tabs.keys.each do |key|
	      if params[:html_options].blank?
	        @options[key] = @tabs[key][0]
	      else
	        @options[key] = params[:html_options][key.to_s].blank? ? @tabs[key][0] : params[:html_options][key.to_s]
	      end
	    end
	end

	def dog_name
		'Hugo Chinga G.'
	end

	def dog_email
		'hugo.chinga.g@gmail.com'
	end

	def perfil?
		if ActiveRecord::Base.connection.table_exists? 'app_perfiles'
			usuario_signed_in? ? AppPerfil.find_by(email: current_usuario.email).present? : false
		else
			usuario_signed_in? ? Perfil.find_by(email: current_usuario.email).present? : false
		end
	end

	def perfil_activo
		if ActiveRecord::Base.connection.table_exists? 'app_perfiles'
			usuario_signed_in? ? AppPerfil.find_by(email: current_usuario.email) : nil
		else
			usuario_signed_in? ? Perfil.find_by(email: current_usuario.email) : nil
		end
	end

	def perfil_activo_id
		usuario_signed_in? ? (perfil_activo.blank? ? nil : perfil_activo.id) : nil
	end

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
		not admin? and not nomina?
	end

	def anonimo?
		not usuario_signed_in?
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

	def number? string
	  true if Float(string) rescue false
	end
end
