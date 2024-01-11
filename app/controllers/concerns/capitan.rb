module Capitan
	extend ActiveSupport::Concern

	# ************************************************************************** INICIALIZA TABLA
	def init_tabla(controller, tabla, paginate)

		# INIT siempre inicializa hash
		@coleccion = {}
		@paginate = {}

		add_tabla(controller, tabla, paginate)
	end

	def add_tabla(controller, tabla, paginate)
		@coleccion[controller] = paginate ? tabla.page(params[:page]) : tabla
		@paginate[controller] = paginate
	end

	# ************************************************************************** INICIALIZA TAB
	def set_tab(token, tabs)

		@tabs = {} if @tabs.blank?
		@options = {} if @options.blank?

		@tabs[token] = tabs
	    @tabs.keys.each do |key|
	    	primer_tab = @tabs[key][0].class.name == 'String' ? @tabs[key][0] : @tabs[key][0][0]
	      if params[:html_options].blank?
	        @options[key] = primer_tab
	      else
	        @options[key] = params[:html_options][key.to_s].blank? ? primer_tab : params[:html_options][key.to_s]
	      end
	    end
	end


	# DEPRECATED
	def init_tab(tabs, options_init)
		@tabs = tabs
		@options = {} if options_init

	    @tabs.keys.each do |key|
	    	primer_tab = @tabs[key][0].class.name == 'String' ? @tabs[key][0] : @tabs[key][0][0]
	      if params[:html_options].blank?
	        @options[key] = primer_tab
	      else
	        @options[key] = params[:html_options][key.to_s].blank? ? primer_tab : params[:html_options][key.to_s]
	      end
	    end
	end

	# **************************************************************************** GENERAL
	def uf_del_dia
		uf = TarUfSistema.find_by(fecha:Time.zone.today.to_date)
		uf.blank? ? nil : uf.valor
	end

	def uf_fecha(fecha)
		uf = TarUfSistema.find_by(fecha: fecha.to_date)
		uf.blank? ? nil : uf.valor
	end

	def enlaces_general
		AppEnlace.where(owner_id: nil).order(:descripcion)
	end

	def enlaces_perfil
		perfil_activo.blank? ? perfil_activo.app_enlaces.order(:descripcion) : nil
	end

end