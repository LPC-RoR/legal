module Capitan
	extend ActiveSupport::Concern

	def devise_controllers
		['confirmations', 'mailer', 'passwords', 'registrations', 'sessions', 'unlocks']
	end

	def admin_controllers
		['app_recursos', 'app_administradores', 'app_nominas', 
			'sb_listas', 'sb_elementos', 
			'st_modelos', 'st_estados', 'st_perfil_modelos', 'st_perfil_estados']
	end

	def admin_controller?(controller)
		admin_controllers.include?(controller)
	end

	# ************************************************************************** INICIALIZA TAB
	def init_tabla(controller, tabla, paginate)

		# INIT siempre inicializa hash
		@coleccion = {}
		@paginate = {}

#		@coleccion[controller] = tabla
#		@paginate[controller] = paginate
		add_tabla(controller, tabla, paginate)
	end

	def add_tabla(controller, tabla, paginate)
		@coleccion[controller] = paginate ? tabla.page(params[:page]) : tabla
		@paginate[controller] = paginate
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

end