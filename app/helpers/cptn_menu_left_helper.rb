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
						['Cliente', 'operación'],
						['Causa', 'operación'],
						['Asesoria', 'admin'],
						['TarAprobacion', 'finanzas'],
						['TarFactura', 'finanzas'],
						['DtMateria', 'admin']
					]
				},
				{
					titulo: 'Tablas',
					condicion: admin?,
					items: [
						{
							titulo: 'Generales',
							condicion: admin?,
							items: [
								['UF & Regiones', 'uf_regiones'],
								['Enlaces', 'enlaces'],
								['Calendario', 'calendario'],
								['Agenda', 'agenda']
							]
						},
						{
							titulo: 'Causas & Asesorias',
							condicion: admin?,
							items:  [
								['Etapas & Tipos', 'tipos'],
								['Cuantías & Tribunales', 'cuantias_tribunales'],
								['Tarifas generales', 'tarifas_generales'],
							]
						},
						{
							titulo: 'Modelo de Negocios',
							condicion: admin?,
							items: [
								['Modelo', 'modelo'],
								['Períodos & Bancos', 'periodos_bancos']
							]
						}
					]
				},
				{
					titulo: 'Administración', 
					condicion: admin?, 
					items: [
						'AppNomina',
						'BlgArticulo',
						'HImagen',
						'StModelo',
						'Variable'
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
		['app_nominas', 'app_enlaces', 'usuarios', 'st_modelos', 'blg_articulos', 'app_versiones', 'h_imagenes', 'app_recursos', 'app_archivos', 'control_documentos', 'tablas']
	end

	def tar_controller
		['tar_aprobaciones', 'tar_facturas', 'tar_tarifas', 'tar_pagos', 'tar_formula_cuantias', 'tar_formulas', 'tar_variable_bases', ]
	end

	def tablas_controllers
		['aut_tipo_usuarios', 'clientes', 'causas', 'asesorias', 'age_actividades', 'age_usuarios', 'age_pendientes', 'hechos', 'temas', 'hecho_archivos', 'tar_valor_cuantias', 'tar_uf_sistemas', 'regiones', 'cal_meses', 'cal_feriados', 'dt_materias', 'variables']
	end

	def left_menu_actions?
		controller_name == 'publicos' and action_name == 'home' and usuario_signed_in? and perfil_activo.present?
	end

	def left_menu_controllers?
		admin_controllers.include?(controller_name) or tablas_controllers.include?(controller_name) or tar_controller.include?(controller_name)
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
	def h_modelo_item
		{
			'AppNomina' => 'Nomina',
			'StModelo' => 'Personalización',
			'TarAprobacion' => 'Aprobaciones',
			'Asesoria' => 'Asesorías',
			'TarUfSistema' => 'UF del día',
			'Region' => 'Región',
			'AppEnlace' => 'Enlaces',
			'CalAnnio' => 'Calendario',
			'AgeUsuario' => 'Usuarios de agenda',
			'TipoCausa' => 'Etapas de Causas',
			'TipoServicio' => 'Tipos de Servicios',
			'TarDetalleCuantia' => 'Ítems de cuantía',
			'TribunalCorte' => 'Juzgados / Cortes',
			'TarTarifa' => 'Tarifas Generales',
			'MModelo' => 'Modelo de Negocios'
		}
	end

	def modelo_item(modelo)
		h_modelo_item[modelo].blank? ? m_to_name(modelo).tableize.capitalize : h_modelo_item[modelo]
	end

end