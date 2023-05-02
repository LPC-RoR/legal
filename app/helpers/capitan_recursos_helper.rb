module CapitanRecursosHelper
	## ------------------------------------------------------- LAYOUTS CONTROLLERS

	def app_sidebar_controllers
		[]
	end

	## ------------------------------------------------------- FORM SCOPES & PARTIALS
	# Maneja los controladores que tienen SCOPE para que las funciones puedan encontrar los partials

	def app_controllers_scope
		{
			tarifas: ['tar_tarifas', 'tar_detalles', 'tar_valores', 'tar_servicios', 'tar_horas', 'tar_facturaciones', 'tar_uf_sistemas', 'tar_detalle_cuantias', 'tar_valor_cuantias', 'tar_pagos', 'tar_formulas', 'tar_comentarios']
		}
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