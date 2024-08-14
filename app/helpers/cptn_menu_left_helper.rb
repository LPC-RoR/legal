module CptnMenuLeftHelper
	## ------------------------------------------------------- MENU

	def menu_left
		{
			admin: [
				{
					titulo: nil,
					condicion: usuario_activo?,
					items: [
						'AgeActividad',
						['Cliente', 'operación'],
						['Causa', 'operación'],
						['Asesoria', 'admin'],
						['Cargo', 'finanzas'],
						['TarAprobacion', 'finanzas'],
						['TarFactura', 'finanzas'],
						['Denuncias', 'operacion'],
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
							titulo: 'Investigaciones',
							condicion: admin?,
							items: [
								['General', 'general'],
								['Archivos Denuncia', 'archivos_denuncia']
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
						'Pautas',
						'LglDocumento',
						'Producto',
						'HmPagina',
						'BlgArticulo',
						'HPregunta',
						'HTexto',
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

	def lm_exclude_action?
		controller_name == 'publicos' and (
				(['home', 'home_prueba'].include?(action_name) and current_usuario.blank?) or
				action_name == 'ayuda'
			)
	end

	def lm_exclude_controller?
		(['servicios'] + devise_controllers).include?(controller_name)
	end

	def lm_sym
		( lm_exclude_action? or lm_exclude_controller?) ? nil : :admin
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