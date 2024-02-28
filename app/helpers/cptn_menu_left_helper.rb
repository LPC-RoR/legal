module CptnMenuLeftHelper
	## ------------------------------------------------------- MENU

	def menu_left
		{
			admin: {
				activo: [
					'AgeActividad',
					'Cliente',
					'Causa',
					'Asesoria',
					'TarAprobacion',
					'TarFactura',
					'DtMateria'
				],
				admin: [
					'AppNomina',
					'Usuario',
					'StModelo',
					'BlgArticulo'
				],
				dog: [
					'AppVersion'
				]
			}
		}
	end

	def admin_controllers
		['app_nominas', 'usuarios', 'st_modelos', 'blg_articulos', 'app_versiones']
	end

	def controller_menu_left(controller)
		if controller == 'app_recursos'
			action_name == 'administracion' ? :admin : nil
		elsif controller != 'servicios' and devise_controllers.exclude?(controller)
			:admin
		else
			nil
		end
	end

	def exception_menu_controllers(controller)
		if controller == 'publicos'
			usuario_signed_in? ? :activo : ( action_name == 'home' ? nil : :publico)
		else
			:activo
		end
	end

	# determina el menú PRIMARIO usándo como parámetro el controlador de lo desplegado
	def menu_left?(controller)
		if devise_controllers.include?(controller)
			nil
		else
			exception_menu_controllers(controller)
		end
	end

	# Determina la RUTA DESTINO usándo como parámetro el modelo del ítem
	def model_link(modelo)
		if modelo == 'Usuario'
			"/app_recursos/usuarios"
		else
			"/#{modelo.tableize}"
		end
	end

	# Determina el MODELO del ítem  dado el controlador desplegado
	def link_model(controller)
		if controller == 'app_recursos'
			"Usuario"
		else
			"#{controller.classify}"
		end
	end

	# Determina el ÍTEM dado el mdoelo del item
	def modelo_item(modelo)
		if modelo == 'AppNomina'
			'Nómina'
		elsif modelo == 'StModelo'
			'Personalización'
		elsif modelo == 'TarAprobacion'
			'Aprobaciones'
		elsif modelo == 'Asesoria'
			'Asesorías'
		else
			m_to_name(modelo).tableize.capitalize
		end
	end

end