module CapitanRecursosHelper

	## ------------------------------------------------------- TABLA | BTNS

	# DEPRECATED EN REVISION
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

	# DEPRECATED EN REVISION
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

	# DEPRECATED EN REVISION (CON REFERENCIAS AUN)
	# usado en _modelo para condicionar despliegue de campos show en tablas
	# true se muestra
	def show_link_condition(objeto)
		true
	end

end