module CapitanRecursosHelper
	## ------------------------------------------------------- GENERAL

	def app_setup
		{
			nombre: 'Legal',
			home_link: 'http://www.legal.cl',
			logo_navbar: 'logo_navbar.gif'
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
			title_tema: 'info',
			detalle_tema: 'info'
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
		[ 'tar_elementos' ]
	end

	def app_bandeja_controllers
		['tar_tarifas', 'tar_detalles', 'tar_valores']
	end

	## ------------------------------------------------------- SCOPES & PARTIALS

	def app_controllers_scope
		{
			tarifas: ['tar_elementos', 'tar_tarifas', 'tar_detalles', 'tar_valores', 'tar_facturaciones', 'tar_servicios']
		}
	end

	def app_scope_controller(controller)
		if app_controllers_scope[:tarifas].include?(controller)
			'tarifas'
		else
			nil
		end
	end

	## ------------------------------------------------------- TABLA | BTNS

	def sortable_fields
		{
			'controller' => ['campo1', 'campo2']
		}
	end

	# En modelo.html.erb define el tipo de fila de tabla
	# Se usa para marcar con un color distinto la fila que cumple el criterio
	# Ejemplo en CVCh
	def table_row_type(objeto)
		'default'
	end

	def app_alias_tabla(controller)
		controller
	end

	def app_new_button_conditions(controller)
		if ['tar_elementos'].include?(controller)
			controller_name == 'app_recursos'
		elsif ['causas'].include?(controller)
			((controller_name == 'clientes' and @objeto.estado == 'activo') or (controller_name == 'st_bandejas' and @e == 'ingreso'))
		elsif ['tar_tarifas', 'tar_valores', 'tar_facturaciones', 'tar_servicios'].include?(controller)
			false
		else
			true
		end
	end

	def app_crud_conditions(objeto, btn)
		if ['TarElemento'].include?(objeto.class.name)
			controller_name == 'app_recursos'
		else
			case objeto.class.name
			when 'Clase'
				admin?
			when 'TarFacturacion'
				false
			else
				true
			end
		end
	end

	def show_link_condition(objeto)
		# usado para condicionar el uso de campos show en tablas
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