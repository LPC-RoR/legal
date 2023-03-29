module CapitanRecursosHelper
	## ------------------------------------------------------- GENERAL

	def app_setup
		{
			nombre: 'Legal',
			home_link: 'http://www.abogadosderechodeltrabajo.cl',
			logo_navbar: 'logo_menu.png'
		}
	end

	def image_size
		{
			portada: nil,
			tema: 'half',
			foot: 'quarter'
		}
	end

	def font_size
		{
			title: 4,
			title_tema: 1,
			detalle_tema: 6
		}
	end

	def app_color
		{
			app: 'dark',
			navbar: 'dark',
			help: 'dark',
			data: 'success',
			title_tema: 'primary',
			detalle_tema: 'primary'
		}
	end

	def image_class
		{
			portada: img_class[:centrada],
			image_tema: img_class[:centrada],
			foot: img_class[:centrada]
		}
	end

	## ------------------------------------------------------- LAYOUTS CONTROLLERS

	def app_sidebar_controllers
		[]
	end

	def app_bandeja_controllers
		['app_directorios', 'app_documentos', 'app_enlaces', 'tar_tarifas', 'tar_detalles', 'tar_facturas', 'app_repos', 'registros', 'reg_reportes', 'tar_horas']
	end

	## ------------------------------------------------------- FORM SCOPES & PARTIALS
	# Maneja los controladores que tienen SCOPE para que las funciones puedan encontrar los partials

	def app_controllers_scope
		{
			tarifas: ['tar_tarifas', 'tar_detalles', 'tar_valores', 'tar_servicios', 'tar_horas', 'tar_facturaciones', 'tar_uf_sistemas', 'tar_detalle_cuantias', 'tar_valor_cuantias', 'tar_pagos', 'tar_formulas', 'tar_comentarios']
		}
	end

	def app_scope_controller(controller)
		if app_controllers_scope[:tarifas].include?(controller)
			'tarifas'
		end
	end

	## ------------------------------------------------------- TABLA | BTNS

	def icon_fields(campo, objeto)
		if objeto.class.name == 'Registro'
			if campo == 'fecha'
				case objeto.tipo
				when 'Informe'
				"bi bi-file-earmark-check"
				when 'Documento'+
				"bi bi-file-earmark-pdf"
				when 'Llamada telefónica'
				"bi bi-telephone"
				when 'Mail'
				"bi bi-envelope-at"
				when 'Reporte'
				"bi bi-file-earmark-ruled"
				end
			end
		end
	end

	def sortable_fields
		{
			'controller' => ['campo1', 'campo2']
		}
	end

	# En modelo.html.erb define el tipo de fila de tabla
	# Se usa para marcar con un color distinto la fila que cumple el criterio
	def table_row_type(objeto)
		case objeto.class.name
		when 'Publicacion'
			if usuario_signed_in?
				(objeto.carpetas.ids & perfil_activo.carpetas.ids).empty? ? 'default' : 'dark'
			else
				'default'
			end
		else
			'default'
		end
	end

	def app_alias_tabla(controller)
		controller
	end

	def app_new_button_conditions(controller)
		if ['contacto_personas', 'contacto_empresas'].include?(controller)
			@e == 'ingreso'
		elsif ['medicamentos', 'diagnosticos', 'antecedente_formaciones', 'fichas', 'tar_tarifas', 'tar_servicios', 'tar_valores', 'tar_horas', 'registros', 'reg_reportes', 'tar_facturaciones', 'tar_valor_cuantias'].include?(controller)
			false
		elsif ['pcds'].include?(controller)
			['st_bandejas'].include?(controller_name)
		elsif ['causas', 'consultorias'].include?(controller)
			controller_name != 'clientes'
		else
			true
		end
	end

	def app_crud_conditions(objeto, btn)
		if [].include?(objeto.class.name)
			admin?
		elsif ['TarFacturacion'].include?(objeto.class.name)
			false
		elsif ['TarPago', 'TarFormula'].include?(objeto.class.name)
			controller_name == 'tar_tarifas'
		else
			case objeto.class.name
			when 'TarValorCuantia'
				controller_name == 'causas' and @options[:menu] == 'Cuantía'
			when 'Registro'
				admin? and objeto.estado == 'ingreso'
			when 'RegReporte'
				false
			else
				true
			end
		end
	end

	def x_conditions(objeto, btn)
		case objeto.class.name
		when 'Clase'
			case btn
			when 'Boton1'
				true
			when 'Boton2'
				false
			end
		else
			true
		end
	end

	def x_btns(objeto)
		case objeto.class.name
		when 'Registro'
			[
				[nil, '/reporta_registro', true],
				['Boton2', '/boton2', true]
			]
        else
        	[]
		end		
	end

	# usado en _modelo para condicionar despliegue de campos show en tablas
	# true se muestra
	def show_link_condition(objeto)
		true
	end

	## ------------------------------------------------------- SHOW

	# Método de apoyo usado en get_new_link (abajo)
	def app_show_title(objeto)
		case objeto.class.name
		when 'Class'
			objeto.titulo
		else
			objeto.send(objeto.class.name.tableize.singularize)
		end
	end
end