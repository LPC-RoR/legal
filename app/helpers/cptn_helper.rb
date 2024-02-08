module CptnHelper

# ******************************************************************** LAYOUTS 

	def no_banner_display?
		controller_name == 'servicios' and action_name == 'aprobacion'
	end

	def footless_controllers
		['servicios']
	end

	def footless_controller?(controller)
		footless_controllers.include?(controller)
	end

# ******************************************************************** CONSTANTES 

	# opcion elegida poor ser de escritura mas simple
	def color(ref)
		if [:app, :navbar].include?(ref)
			config[:color][ref]
		elsif ['hlp_tutoriales', 'hlp_pasos'].include?(ref)
			config[:color][:help]
		else
			config[:color][:app]
		end
	end

	def table_types_base
		{
			simple: '',
			striped: 'table-striped',
			bordered: 'table-bordered',
			borderless: 'table-borderless',
			hover: 'table-hover',
			small: 'table-small'
		}
	end

# ******************************************************************** HELPERS DE USO GENERAL

	def nombre(objeto)
		objeto.send(objeto.class.name.tableize.singularize)
	end

	def perfiles_operativos
		AppNomina.all.map {|nomina| nomina.nombre}.union(AppAdministrador.all.map {|admin| admin.administrador unless admin.email == 'hugo.chinga.g@gmail.com'}.compact)
	end

	# Manejode options para selectors múltiples (VERSION PARA MULTI TABS SIN CAMBIOS)
	def get_html_opts(options, label, value)
		opts = options.clone
		opts[label] = value
		opts
	end

	def controller_icon
		{
			'clientes' => 'building',
			'causas' => 'journal-text',
			'asesorias' => 'briefcase',
			'tablas' => 'table',
			'regiones' => 'geo-alt',
			'tipo_causas' => 'file-check',
			'tribunal_cortes' => 'bank',
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
			'app_documentos' => 'files',
			'app_archivos' => 'file',
			'app_enlaces' => 'box-arrow-up-right',
			'm_periodos' => 'calendar3',
			'm_modelos' => 'piggy-bank',
			'm_cuentas' => 'safe2',
			'm_formatos' => 'file-spreadsheet',
			'sb_listas' => 'list-nested',
			'app_empresas' => 'buildings',
			'app_administradores' => 'person-badge',
			'app_nominas' => 'person-workspace',
			'usuarios' => 'person',
			'app_repos' => 'archive',
			'app_directorios' => 'folder',
			'app_escaneos' => 'images',
			'm_bancos' => 'bank',
			'blg_articulos' => 'file-earmark-richtext',
			'blg_temas' => 'list-stars',
			'age_actividades' => 'calendar4-event',
			'age_usuarios' => 'person-workspace',
			'app_versiones' => 'gear',
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

	def s_mes(datetime)
		"#{datetime.year} #{nombre_mes[datetime.month]}"
	end

	def s_rut(rut)
		rut.gsub(' ', '').insert(-8, '.').insert(-5, '.').insert(-2, '-')
	end
end
