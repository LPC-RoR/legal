module ApplicationHelper
	## ------------------------------------------------------- HOME

	def img_class 
		{
			centrada: 'mx-auto d-block'
		}
	end

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

	def colors
		['primary', 'secondary', 'success', 'danger', 'warning', 'info', 'light', 'dark', 'muted', 'white']
	end

	def image_sizes
		['entire', 'half', 'quarter', 'thumb']
	end

	def foot?
		h_imagen = HImagen.find_by(nombre: 'Foot')
		h_imagen.blank? ? false : (h_imagen.imagenes.empty? ? false : h_imagen.imagenes.first.present?)
	end

	# DEPRECATED
#	def objeto_tema_ayuda(tipo)
#		TemaAyuda.where(tipo: tipo).any? ? TemaAyuda.where(tipo: tipo).first : nil
#	end

	# DEPRECATED
#	def coleccion_tema_ayuda(tipo)
#		temas_ayuda_tipo = TemaAyuda.where(tipo: tipo)
#		if temas_ayuda_tipo.any?
#			temas_ayuda_activos = temas_ayuda_tipo.where(activo: true)
#			temas_ayuda_activos.any? ? temas_ayuda_activos.order(:orden) : nil
#		else
#			nil
#		end
#	end

	## ------------------------------------------------------- TABLA

	def table_types(controller)
		if ['app_directorios', 'app_documentos', 'app_archivos'].include?(controller)
			table_types_base[:borderless]
		else
			table_types_base[:striped]
		end
	end

	# Obtiene los campos a desplegar en la tabla desde el objeto
	def m_tabla_fields(objeto)
		objeto.class::TABLA_FIELDS
	end

	def sortable?(controller, field)
		if sortable_fields[controller].present?
			sortable_fields[controller].include?(field) ? true : false
		else
			false
		end
	end

	def sortable(column, title = nil)
	  title ||= column.titleize
	  css_class = column == sort_column ? "current #{sort_direction}" : nil
	  direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
	  link_to title, {:sort => column, :direction => direction, html_options: @options}, {:class => css_class}
	end

	## ------------------------------------------------------- TABLA | BTNS
	
	# Link de un x_btn del modelo de una tabla
	# objeto : objeto del detalle de la tabla
	# accion : url al que hay que sumarle los parámetros}
	# objeto_ref : true => se incluyen parámetros de @objeto
	def link_x_btn(objeto, accion, objeto_ref)
		ruta_raiz = "/#{objeto.class.name.tableize}/#{objeto.id}#{accion}"
		ruta_objeto = (objeto_ref and @objeto.present?) ? "#{(!!accion.match(/\?+/) ? '&' : '?')}class_name=#{@objeto.class.name}&objeto_id=#{@objeto.id}" : ''
		"#{ruta_raiz}#{ruta_objeto}"
	end

	# pregunta si tiene childs
	# "_btns_e.html.erb"
	def has_child?(objeto)
		# Considera TODO, hasta los has_many through
		objeto.class.reflect_on_all_associations(:has_many).map { |a| objeto.send(a.name).any? }.include?(true)
	end

	## ------------------------------------------------------- FORM
	# Este helper encuentra el partial que se debe desplegar como form
	# originalmente todos llegaban a _form
	# ahora pregunta si hay un partial llamado _datail en el directorio de las vistas del modelo
	def detail_partial(controller)
		# partial?(controlller, dir, partial)
		if partial?(controller, nil, 'detail')
			get_partial(controller, nil, 'detail')
		else
			'0p/form/detail'
		end
	end

	def url_params(parametros)
		params_options = "n_params=#{parametros.length}"
		parametros.each_with_index do |obj, indice|
			params_options = params_options+"&class_name#{indice+1}=#{obj.class.name}&obj_id#{indice+1}=#{obj.id}"
		end
		params_options
	end

	## -------------------------------------------------------- TABLA & SHOW

	# obtiene el nombre del campo puro desde la descripción de TABLA_FIELDS
	def get_field_name(label)
		label.split(':').last.split('#').last
	end

	# Obtiene el campo para despleagar en una TABLA
	# Acepta los sigueintes labels:
	# 1.- archivo:campo : archivo es un campo has_one o belongs_to y campo es el nombre del campo de esa relación
	# 2.- campo : campo es el campo del objeto
	# 3.- i#campo : es un campo que va antecedido de un ícono
	# Resuelve BT_FIELDS y d_<campo> si es necesario 
	def get_field(label, objeto)
		#Debe resolver archivo:k*#campo
		# [archivo, archivo, campo]

		# Variables de la función
		v = label.split(':')               # vector de palabras en label
		archivos = v.slice(0, v.length-1)  # vector que tienen todos los archivos
		nombre = v.last                    # nombre del campo

		# se avanza por los archivos hasta el último
		archivo = objeto
		archivos.each do |arch|
			archivo = archivo.send(arch)
		end

		v_nombre = nombre.split('#')
		campo = v_nombre.last
		prefijos = v_nombre - [v_nombre.last]

		unless archivo.send(campo).blank?
			if ['DateTime', 'Time'].include?(archivo.send(campo).class.name)
				texto_campo = dma(archivo.send(campo))
			elsif prefijos.include?('uf') 
				texto_campo = number_to_currency(archivo.send(campo), unit: 'UF', precision: 2, format: '%u %n')
			elsif prefijos.include?('$')
				texto_campo = number_to_currency(archivo.send(campo), precision: 0, unit: '$', format: '%u %n')
			elsif prefijos.include?('$2')
				texto_campo = number_to_currency(archivo.send(campo), precision: 2, unit: '$', format: '%u %n')
			elsif prefijos.include?('m')
				texto_campo = number_to_currency(archivo.send(campo), precision: "#{archivo.send('moneda') == 'Pesos' ? '0' : '2'}}".to_i, unit: "#{archivo.send('moneda') == 'Pesos' ? '$' : 'UF'}", format: '%u %n')
			else
				texto_campo = archivo.send(campo)
			end
			[texto_campo, prefijos, archivo.send(campo).class.name]
		else
			nil
		end

	end

	## ------------------------------------------------------- SHOW

	def show_title(objeto)
		case objeto.class.name
		when 'SbLista'
			objeto.lista
		when 'SbElemento'
			objeto.elemento
		when 'HlpTutorial'
			objeto.tutorial
		else
			app_show_title(objeto)
		end
	end

	def status?(objeto)
		# partial?(controlller, dir, partial)
		partial?(controller, nil, 'status')
	end

	## ------------------------------------------------------- GENERAL

	# Manejode options para selectors múltiples (VERSION PARA MULTI TABS SIN CAMBIOS)
	def get_html_opts(options, label, value)
		opts = options.clone
		opts[label] = value
		opts
	end

	## ------------------------------------------------------- LIST

	def text_with_badge(text, badge_value=nil)
	    badge = content_tag :span, badge_value, class: 'badge badge-primary badge-pill'
	    text = raw "#{text} #{badge}" if badge_value
	    return text
	end

	## ------------------------------------------------------- GENERAL
	def perfiles_operativos
		AppNomina.all.map {|nomina| nomina.nombre}.union(AppAdministrador.all.map {|admin| admin.administrador unless admin.email == 'hugo.chinga.g@gmail.com'}.compact)
	end

	## ------------------------------------------------------- PUBLICACION

	def get_evaluacion_publicacion(publicacion, item)
		e = perfil_activo.evaluaciones.find_by(aspecto: item, publicacion_id: publicacion.id)
		e.blank? ? '[no evaluado]' : e.evaluacion
	end

	def get_btns_evaluacion(publicacion, item)
		eval_actual = publicacion.evaluaciones.find_by(aspecto: item)
		excluido = eval_actual.blank? ? [] : [eval_actual.evaluacion]
		Publicacion::EVALUACION[item] - excluido
	end

end
