module Capitan
	extend ActiveSupport::Concern

	# ************************************************************************** INICIALIZA TABLA
	def set_tabla(controller, tabla, paginate)
		
		@coleccion = {} if @coleccion.blank?
		@paginate = {} if @paginate.blank?

		@coleccion[controller] = paginate ? tabla.page(params[:page]) : tabla
		@paginate[controller] = paginate

	end

	# ************************************************************************** TAB
	# set_tab(:menu, ['Pendientes', 'Realizadas'])
	# <%= render partial: '0p/tabs/tabs', locals: { token: :monitor } %>
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
		perfil_activo.blank? ? [] : AppEnlace.where(owner_class: 'AppPerfil', owner_id: perfil_activo.id).order(:descripcion)
	end

end