class ApplicationController < ActionController::Base

	include IniciaAplicacion

	helper_method :dog?, :admin?, :nomina?, :general?, :anonimo?, :seguridad_desde, :dog_email, :dog_name, :perfil?, :perfil_activo, :perfil_activo_id

	def inicia_sesion

		set_tablas_base if dog?

		if usuario_signed_in? and perfil_activo.blank?

			# Perro furioso
			if ActiveRecord::Base.connection.table_exists? 'app_administradores'
				@dog = AppAdministrador.find_by(email: dog_email)
				@dog = AppAdministrador.create(administrador: dog_name, email: dog_email) if @dog.blank?
			else
				@dog = Administrador.find_by(email: dog_email)
				@dog = Administrador.create(administrador: dog_name, email: dog_email) if @dog.blank?
			end

			@perfil = perfil_activo

			if @perfil.blank?
				# TODAS las aplicaciones en Capitan tienen una tabla 'administradores'
				if ActiveRecord::Base.connection.table_exists? 'app_administradores'
					administrador = AppAdministrador.find_by(email: current_usuario.email)
				else
					administrador = Administrador.find_by(email: current_usuario.email)
				end

				if administrador.present?
					if ActiveRecord::Base.connection.table_exists? 'app_perfiles'
						@perfil = AppPerfil.create(email: current_usuario.email, app_administrador_id: administrador.id)
					else 
						@perfil = Perfil.create(email: current_usuario.email, administrador_id: administrador.id)
					end
				end

				if @perfil.blank?
					# Las aplicaciones con Capitan que NO tienen tabla 'nominas' se asume que tienen LIBRE REGISTRO
					if ActiveRecord::Base.connection.table_exists? 'app_nominas'
						nomina = AppNomina.find_by(email: current_usuario.email)
					else
						nomina = Nomina.find_by(email: current_usuario.email)
					end

					# Hay Aplicaciones que tienen libre registro de usuarios, otros no!
					if nomina.present?
						if ActiveRecord::Base.connection.table_exists? 'app_perfiles'
							@perfil = AppPerfil.create(email: current_usuario.email)
						else 
							@perfil = Perfil.create(email: current_usuario.email)
						end
					end
				end

				if @perfil.blank? and libre_registro
					# LIBRE REGISTRO
					if ActiveRecord::Base.connection.table_exists? 'app_perfiles'
						@perfil = AppPerfil.create(email: current_usuario.email)
					else 
						@perfil = Perfil.create(email: current_usuario.email)
					end
				end

			end

			# Reparar perfiles si fuera necesario
			if @perfil.present?
				if ActiveRecord::Base.connection.table_exists? 'app_perfiles'
					if @perfil.app_administrador.blank?
						adm = AppAdministrador.find_by(email: @perfil.email)
						if adm.present?
							@perfil.app_administrador_id = adm.id
							@perfil.save
						end
					end
				else
					if @perfil.app_administrador.blank?
						adm = Administrador.find_by(email: @perfil.email)
						if adm.present?
							@perfil.administrador_id = adm.id
							@perfil.save
						end
					end
				end
			end

			inicia_app if @perfil.present?

		end
	end

	# Este método se usa para construir un nombre de directorio a partir de un correo electrónico.
	def archivo_usuario(email, params)
		email.split('@').join('-').split('.').join('_')
	end

	# ************************************************************************** INICIALIZA TAB
	def init_tab(tabs, tab_id)
		@tabs = tabs[0].class.name == 'String' ? tabs : tabs.map {|item| item[0] if item[1] }.compact
		if params[:html_options].blank?
		  @tab = @tabs[0]
		else
		  @tab = params[:html_options][:tab].blank? ? @tabs[0] : params[:html_options][:tab]
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
