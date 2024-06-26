module CptnMenuAppHelper

	def menu_base
	    [
	        [nil,        "/blg_articulos",               'nomina', controller_icon['blg_articulos'], 'Blogs'],
	        [nil,         '/app_recursos/administracion', 'admin', 'person-rolodex', 'Administración'],
#	        ["Contenido",  "/tema_ayudas",                 'admin', 'stack'],
#	        [nil, "/app_recursos/procesos",       'dog',   'radioactive']
	    ]
	end

	def menu
	    ## Menu principal de la aplicación
	    # [ 'Item del menú', 'link', 'accesso', 'gly' ]
	    [
	        ['Clientes',       "/clientes",             'nomina', 'building',                       'Clientes'],
	        ['Causas',       "/causas",               'nomina', 'journal-text',                   'Causas'],
	        ['Asesorías',       "/asesorias",            'nomina', 'briefcase',                      'Asesorías'],
	        ['Aprobaciones',       "/tar_aprobaciones",     'nomina', 'check-all',                      'Aprobaciones'],
	        ['Facturas',       "/tar_facturas",         'nomina', 'receipt',                        'Facturas'],
#	        [nil,       "/app_repositorios",     'nomina', controller_icon['app_repos'],     'Repositorios de documentos'],
	        [nil,       "/m_modelos",            'nomina', controller_icon['m_modelos'],     'Modelo de negocios'],
	        [nil,       "/tablas",               'nomina', 'table',                          'Tablas'],
	        [nil,       "/dt_materias",          'nomina', 'bank',                           'Materias']
	    ]

	end

	def dd_items(item)
		case item
		when 'Valores'
			[
				['Tarifas Base', '/tar_tarifas'],
				['Facturas', 'tar_facturas']
			]
		when 'Documentos'
			[
				['Compartidos', '/app_repos/publico'],
				['Personales', '/app_repos/perfil']
			]
		when 'Enlaces'
			[
			]
		end
	end

end