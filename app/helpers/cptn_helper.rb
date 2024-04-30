module CptnHelper

# ******************************************************************** LAYOUTS 

	def no_over_controllers
		['servicios']
	end

	def no_over_layout?
		no_over_controllers.include?(controller_name)
	end

	def no_over_menu_controllers
		[]
	end

	def no_over_menu_layout?
		no_over_menu_controllers.include?(controller_name)
	end

	def no_banner_controllers
		[]
	end

	def no_banner_layout?
		no_banner_controllers.include?(controller_name)
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

    def archivos_controlados_disponibles
    	st_modelo = StModelo.find_by(st_modelo: 'Hecho')
    	st_modelo.blank? ? [] : st_modelo.control_documentos.order(:orden)
    end

	def controller_icon
		{
			'usuarios' => 'person',
			'app_versiones' => 'gear',
			'app_nominas' => 'person-workspace',
			'app_documentos' => 'files',
			'app_archivos' => 'file',
			'app_enlaces' => 'box-arrow-up-right',
			'h_imagenes' => 'image',
			'clientes' => 'building',
			'causas' => 'journal-text',
			'asesorias' => 'briefcase',
			'tablas' => 'table',
			'regiones' => 'geo-alt',
			'tipo_causas' => 'file-check',
			'tribunal_cortes' => 'bank',
			'hechos' => 'check2-circle',
			'tar_aprobaciones' => 'check-all',
			'tar_facturaciones' => 'coin',
			'tar_facturas' => 'receipt',
			'tar_tarifas' => 'cash-coin',
			'tar_servicios' => 'cash-coin',
			'tar_detalle_cuantias' => 'check2-square',
			'tar_valor_cuantias' => 'currency-dollar',
			'tar_uf_sistemas' => 'calendar3',
			'tar_uf_facturaciones' => 'currency-dollar',
			'tar_pagos' => 'currency-dollar',
			'tar_formulas' => 'lightbulb',
			'tar_comentarios' => 'chat',
			'st_modelos' => 'box',
			'dt_materias' => 'bank',
			'm_periodos' => 'calendar3',
			'm_modelos' => 'piggy-bank',
			'm_cuentas' => 'safe2',
			'm_formatos' => 'file-spreadsheet',
			'sb_listas' => 'list-nested',
			'app_empresas' => 'buildings',
			'app_repos' => 'archive',
			'app_directorios' => 'folder',
			'app_escaneos' => 'images',
			'm_bancos' => 'bank',
			'blg_articulos' => 'file-earmark-richtext',
			'blg_temas' => 'list-stars',
			'age_actividades' => 'calendar4-event',
			'age_usuarios' => 'person-workspace',
			'cal_annios' => 'calendar',
			'cal_meses' => 'calendar3',
			'cal_semanas' => 'calendar2-week',
			'cal_feriados' => 'calendar2-check'
		}
	end

# ******************************************************************** DESPLIEGUE DE CAMPOS

	def s_moneda(moneda, valor)
		moneda == 'Pesos' ? s_pesos(valor) : s_uf(valor)
	end

	def s_pesos(valor)
		number_to_currency(valor, locale: :en, precision: config[:decimales]['Pesos'])
	end

	def s_pesos2(valor)
		number_to_currency(valor, locale: :en, precision: 2)
	end

	def s_uf(valor)
		number_to_currency(valor, unit: 'UF', precision: config[:decimales]['UF'])
	end

	def s_uf5(valor)
		number_to_currency(valor, unit: 'UF', precision: 5)
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
		rut.gsub(' ', '').insert(-8, '.').insert(-5, '.').insert(-2, '-')
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
