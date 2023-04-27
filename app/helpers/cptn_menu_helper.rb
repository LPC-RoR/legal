module CptnMenuHelper

	def menu_base
	    [
#	        ['',        app_enlaces_path,     'nomina', 'nut'],
	        ['',           '/app_recursos/administracion', 'admin', 'person-rolodex'],
#	        ["Contenido",  "/tema_ayudas",                 'admin', 'stack'],
	        ["Procesos",   "/app_recursos/procesos",       'dog',   'radioactive']
	    ]
	end

	def menu
	    ## Menu principal de la aplicación
	    # [ 'Item del menú', 'link', 'accesso', 'gly' ]
	    [
	        ['',        "/st_bandejas",         'nomina', 'inboxes'],
	        ['',        "/app_repos/1",         'nomina', 'file-earmark-text'],
	        ['',        "/app_repos/perfil",    'nomina', 'file-earmark-person'],
	        ['',        "/app_recursos/tablas", 'nomina', 'table'],
	        ['',        "/tar_facturas",        'nomina', 'check-all']
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

	def display_item_app(item, tipo_item)
		true
	end

end