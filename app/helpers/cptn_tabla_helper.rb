module CptnTablaHelper

	def no_th_controllers
		['directorios', 'documentos', 'archivos', 'imagenes']
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

	# Objtiene LINK DEL BOTON NEW
	def get_new_link(controller)
		# distingue cuando la tabla está en un index o en un show
		(controller_name == get_controller(controller) or @objeto.blank?) ? "/#{get_controller(controller)}/new" : "/#{@objeto.class.name.tableize}/#{@objeto.id}/#{get_controller(controller)}/new"
	end

	def new_path(src, ownr)
		"/#{cntrllr(src)}/new#{ownr_prms(ownr) unless ownr.blank?}"
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

	# obtiene el nombre del campo puro desde la descripción de TABLA_FIELDS
	def get_field_name(label)
		label.split(':').last.split('#').last
	end

	# Obtiene el campo para despleagar en una TABLA
	# Acepta los siguientes labels:
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
			archivo = archivo.send(arch) unless archivo.blank?
		end

		v_nombre = nombre.split('#')
		campo = v_nombre.last
		prefijos = v_nombre - [v_nombre.last]

		unless archivo.blank? or archivo.send(campo).blank?
			if ['DateTime', 'Time'].include?(archivo.send(campo).class.name)
				texto_campo = dma(archivo.send(campo))
			elsif prefijos.include?('uf') 
				texto_campo = number_to_currency(archivo.send(campo), unit: 'UF', precision: cfg_defaults[:uf], format: '%u %n')
			elsif prefijos.include?('$')
				texto_campo = number_to_currency(archivo.send(campo), precision: cfg_defaults[:pesos], unit: '$', format: '%u %n')
			elsif prefijos.include?('$2')
				texto_campo = number_to_currency(archivo.send(campo), precision: 2, unit: '$', format: '%u %n')
			elsif prefijos.include?('m')
				texto_campo = number_to_currency(archivo.send(campo), precision: "#{archivo.send('moneda') == 'Pesos' ? '0' : '5'}}".to_i, unit: "#{archivo.send('moneda') == 'Pesos' ? '$' : 'UF'}", format: '%u %n')
			else
				texto_campo = archivo.send(campo)
			end
			[texto_campo, prefijos, archivo.send(campo).class.name]
		else
			nil
		end

	end

	# -------------------------------------------------------- FORM

	# ULTIMA VERSION : Sólo se trabaja con '_detail.html.erb'
	# source {controller, objeto}
	def detail_partial(source)
		c = cntrllr(source)
		prtl_nm = prtl_name(c, nil, 'detail')
		fl = prtl_to_file(prtl_nm)
		prtl_file?(prtl_to_file(prtl_nm)) ? prtl_nm : nil
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

end