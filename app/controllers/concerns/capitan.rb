module Capitan
	extend ActiveSupport::Concern

	def swtch_rdrccn
		if ['KrnDenunciante', 'KrnDenunciado', 'KrnInvDenuncia'].include?(@objeto.class.name)
			@objeto.krn_denuncia
		elsif @objeto.class.name == 'KrnDenuncia'
			@objeto
		elsif ['Nota'].include?(@objeto.class.name)
			case @objeto.ownr.class.name
			when 'Causa'
				causas_path
			end
		else
			@objeto.ownr
		end
	end

	def swtch
		@objeto[params[:tkn]] = @objeto.send(params[:tkn]) ? false : true
		@objeto.save

		redirect_to swtch_rdrccn
	end

	def swtch_clr
		@objeto[params[:tkn]] = params[:clr]
		@objeto.save

		redirect_to swtch_rdrccn
	end

	# ************************************************************************** INICIALIZA VARIALES PARA CHANGE_STATE
    def set_st_estado(objeto)
    	st_modelo = StModelo.find_by(st_modelo: objeto.class.name)
    	@st_estado = st_modelo.blank? ? nil : st_modelo.st_estados.find_by(st_estado: objeto.estado)
    	@st_usuario = @st_estado.blank? ? [] : @st_estado.destinos.split(' ').map {|std| std if check_st_estado(objeto, std)}.compact
    	@st_admin = @st_estado.blank? ? [] : @st_estado.destinos_admin.split(' ').map {|std| std if check_st_estado(objeto, std)}.compact
    end

	# ************************************************************************** TABLA
	def set_tabla(controller, tabla, paginate)
		
		@coleccion = {} if @coleccion.blank?
		@paginate = {} if @paginate.blank?

		@coleccion[controller] = paginate ? tabla.page(params[:page]) : tabla
		@paginate[controller] = paginate

	end

	# ************************************************************************** INICIALIZA TAB
	def get_primer_tab(key)
		primer = nil
		@tabs[key].each do |tab|
			if primer.blank?
				primer = tab.class.name == 'String' ? tab : (tab[1] ? tab[0] : nil)
			end
		end
		primer
	end

	# set_tab(:menu, ['Pendientes', 'Realizadas'])
	# <%= render partial: '0p/tabs/tabs', locals: { token: :monitor } %>
	def set_tab(token, tabs)

		@tabs = {} if @tabs.blank?
		@options = {} if @options.blank?

		@tabs[token] = tabs
	    @tabs.keys.each do |key|
	    	primer_tab = get_primer_tab(key)
			if params[:html_options].blank?
				@options[key] = primer_tab
			else
				@options[key] = params[:html_options][key.to_s].blank? ? primer_tab : params[:html_options][key.to_s]
			end
	    end
	end

	# **************************************************************************** WTCHS
	# Aplicados en Causa, Asesoría y Cliente

  def swtch_prrdd
    # {negro, verde, amarillo, rojo}
    @objeto.prioridad = params[:prioridad] == 'nil' ? nil : params[:prioridad]
    @objeto.save

		red = @objeto.class.name == 'Nota' ? "/#{@objeto.ownr.class.name.tableize}" : "/#{@objeto.class.name.tableize}"
		redirect_to red
  end

	def swtch_prprty
		case params[:prprty]
		when 'preferente'
			@objeto.preferente = @objeto.preferente ? false : true
		end
		@objeto.save

		red = @objeto.class.name == 'Nota' ? "/#{@objeto.owner.class.name.tableize}" : "/#{@objeto.class.name.tableize}"
		redirect_to red
	end

 	def swtch_pendiente
		@objeto.pendiente = @objeto.pendiente ? false : true
		@objeto.save

		red = @objeto.class.name == 'Nota' ? "/#{@objeto.owner.class.name.tableize}" : "/#{@objeto.class.name.tableize}"
		redirect_to red
	end

	def swtch_urgencia
		@objeto.urgente = @objeto.urgente ? false : true
		@objeto.save

		red = @objeto.class.name == 'Nota' ? "/#{@objeto.owner.class.name.tableize}" : "/#{@objeto.class.name.tableize}"
		redirect_to red
	end

	# **************************************************************************** GENERAL
	def object_class_sym(objeto)
		objeto.class.name.tableize.to_sym
	end

	def uf_del_dia
		uf = TarUfSistema.find_by(fecha: Time.zone.today.to_date)
		uf.blank? ? nil : uf.valor
	end

	# usado en el cálculo de tarifas y despliegue de pagos
	def uf_fecha(fecha)
		uf = fecha.blank? ? nil : TarUfSistema.find_by(fecha: fecha.to_date)
		uf.blank? ? nil : uf.valor
	end

	def vlr_uf(fecha)
		uf = fecha.blank? ? nil : TarUfSistema.find_by(fecha: fecha.to_date)
		uf.blank? ? nil : uf.valor
	end

	def limpia_nombre(string)
		string.gsub(/\t|\r|\n/, ' ').strip.downcase
	end

	def v_enlaces_general
		gnrl = AppEnlace.gnrl
		gnrl.empty? ? nil : gnrl.map {|enlace| {texto: enlace.descripcion, link: enlace.enlace}}
	end

	def v_enlaces_perfil
		prfl_lnks = perfil_activo.app_enlaces
		prfl_lnks.empty? ? nil : prfl_lnks.map {|enlace| {texto: enlace.descripcion, link: enlace.enlace}}
	end

	def v_enlaces
		[v_enlaces_perfil, v_enlaces_general].compact
	end

	# MANEJO DE DATETIME EN FORMS 

	def dt_hoy
		Time.zone.today
	end

	def s_hoy
		dt_hoy.strftime("%Y-%m-%dT%k:%M")
	end

	def params_to_date(prms, date_field)
		annio = prms["[#{date_field.strip}(1i)]"].to_i
		mes = prms["[#{date_field.strip}(2i)]"].to_i
		dia = prms["[#{date_field.strip}(3i)]"].to_i
		DateTime.new(annio, mes, dia, 0, 0, 0, "#{Time.zone.utc_offset/3600}")
	end

	def prms_to_date_raw(prms, date_field)
		annio = prms["#{date_field.strip}(1i)"].to_i
		mes = prms["#{date_field.strip}(2i)"].to_i
		dia = prms["#{date_field.strip}(3i)"].to_i
		DateTime.new(annio, mes, dia, 0, 0, 0, "#{Time.zone.utc_offset/3600}")
	end

	def prm_safe(prm)
		CGI.escape(prm)
	end
end