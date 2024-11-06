module CptnHelper

# ******************************************************************** LAYOUTS 

	def no_over_controllers
		['servicios']
	end

	def no_over_layout?
		no_over_controllers.include?(controller_name)
	end

	def no_foot_controllers
		['servicios']
	end

	def no_foot_layout?
		no_foot_controllers.include?(controller_name)
	end

	def img_banner
		h_imagen = HImagen.find_by(nombre: 'Banner')
		unless h_imagen.blank?
			h_imagen.imagenes.empty? ? nil : h_imagen.imagenes.order(created_at: :desc).first.imagen.over.url
		else
			nil
		end
	end

# ******************************************************************** CONSTANTES 

	#Cambiar paulatinamente por cfg_color
	def color(ref)
		cfg_color[ref]
	end

# ******************************************************************** HELPERS DE USO GENERAL

	def s_as_prms(string)
		string.split(' ').join('_')
	end

	def nombre(objeto)
		objeto.send(objeto.class.name.tableize.singularize)
	end

	def perfiles_operativos
		AppNomina.all.map {|nomina| nomina.nombre}.compact
	end

	# Manejo de options para selectors múltiples (VERSION PARA MULTI TABS SIN CAMBIOS)
	def get_html_opts(options, label, value)
		opts = options.clone
		opts[label] = value
		opts
	end

	def tipos_usuario
		AutTipoUsuario.all.order(:aut_tipo_usuario).map {|atu| atu.aut_tipo_usuario}
	end

    def archivos_controlados_disponibles
    	st_modelo = StModelo.find_by(st_modelo: 'Hecho')
    	st_modelo.blank? ? [] : st_modelo.control_documentos.order(:orden)
    end

# ******************************************************************** DESPLIEGUE DE CAMPOS

	def s_moneda(moneda, valor)
		moneda == 'Pesos' ? s_pesos(valor) : s_uf(valor)
	end

	def s_pesos(valor)
		number_to_currency(valor, locale: :en, precision: cfg_defaults[:pesos])
	end

	def s_pesos2(valor)
		number_to_currency(valor, locale: :en, precision: 2)
	end

	def s_uf(valor)
		number_to_currency(valor, unit: 'UF', precision: cfg_defaults[:uf])
	end

	def s_uf5(valor)
		number_to_currency(valor, unit: 'UF', precision: cfg_defaults[:uf_calculo])
	end

	def s_p100(valor, decimales)
		number_to_currency(valor, unit: '%', precision: decimales)
	end

	def dma(date)
		date.blank? ? '__-__-__' : date.strftime("%d-%m-%Y")
	end

	def hm(datetime)
		datetime.blank? ? '__:__' : datetime.strftime("%I:%M%p")
	end

	def dma_hm(date)
		date.blank? ? '__-__-__ __:__' : date.strftime("%d-%m-%Y  %I:%M%p")
	end

	def hm(date)
		date.blank? ? '__:__' : date.strftime("%I:%M%p")
	end

	def s_mes(datetime)
		"#{datetime.year} #{nombre_mes[datetime.month]}"
	end

	def s_rut(rut)
		rut.blank? ? '##.###.###-#' : rut.gsub(' ', '').insert(-8, '.').insert(-5, '.').insert(-2, '-')
	end
# ******************************************************************** HOME

	def img_portada
		h_imagen = HImagen.find_by(nombre: 'Portada')
		h_imagen.blank? ? nil : (h_imagen.imagenes.empty? ? nil : h_imagen.imagenes.order(created_at: :desc).first)
	end

	def img_foot
		h_imagen = HImagen.find_by(nombre: 'Foot')
		h_imagen.blank? ? nil : (h_imagen.imagenes.empty? ? nil : h_imagen.imagenes.order(created_at: :desc).first)
	end

	def foot?
		h_imagen = HImagen.find_by(nombre: 'Foot')
		h_imagen.blank? ? false : (h_imagen.imagenes.empty? ? false : h_imagen.imagenes.first.present?)
	end

end
