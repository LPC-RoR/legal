module CptnMenuLeftHelper
	## ------------------------------------------------------- MENU

	def menu_left
		{
			admin: [
				{
					titulo: nil,
					condicion: usuario?,
					items: [
						'AgeActividad',
						'Cliente',
						'Causa',
						'Asesoria',
						'TarAprobacion',
						'TarFactura',
						'DtMateria'
					]
				},
				{
					titulo: 'Tablas', 
					condicion: admin? 
				},
				{
					titulo: 'Administracion', 
					condicion: admin?, 
					items: [
						'AppNomina',
						'StModelo',
						'BlgArticulo',
						'HImagen'
					]
				},
				{
					titulo: 'App', 
					condicion: dog?, 
					items: [
						'AppVersion',
						'AutTipoUsuario'
					]
				}
			]
		}
	end

	def admin_controllers
		['app_nominas', 'usuarios', 'st_modelos', 'blg_articulos', 'app_versiones', 'h_imagenes']
	end

	def tablas_controllers
		['aut_tipo_usuarios', 'clientes', 'causas', 'asesorias', 'tar_aprobaciones', 'tar_facturas', 'tablas', 'tar_tarifas', 'tar_pagos', 'tar_formula_cuantias', 'tar_formulas', 'tar_variable_bases']
	end

	def left_menu_actions?
		controller_name == 'publicos' and action_name == 'home' and usuario_signed_in?
	end

	def left_menu_controllers?
		admin_controllers.include?(controller_name) or tablas_controllers.include?(controller_name)
	end

	def left_menu_sym
		( left_menu_actions? or left_menu_controllers?) ? :admin : nil
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