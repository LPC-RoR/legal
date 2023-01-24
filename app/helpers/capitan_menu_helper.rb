module CapitanMenuHelper

	def optional_menu_item
		{
			recursos: false,
			contacto: true,
			ayuda: true,
			enlaces: true
		}
	end

	def menu_base
	    [
	        ['',           '/app_recursos/administracion', 'admin', 'person-rolodex'],
#	        ["Contenido",  "/tema_ayudas",                 'admin', 'stack'],
	        ["Procesos",   "/app_recursos/procesos",       'dog',   'radioactive']
	    ]
	end

	def menu
	    ## Menu principal de la aplicación
	    # [ 'Item del menú', 'link', 'accesso', 'gly' ]
	    [
	        ['',        "/st_bandejas",       'nomina', 'inboxes'],
	        ['Público', '/app_repos/publico', 'nomina', 'archive'],
	        ['Perfil',  '/app_repos/perfil',  'nomina', 'archive'],
	        ['',        "/tar_facturas",      'nomina', 'currency-dollar'],
#	        ['',        "/tar_bases",         'admin',  'receipt'],
	        ['',        app_enlaces_path,     'nomina', 'link']
	    ]

	end

	def dropdown_items(item)
		case item
		when 'Investigación'
			[
#				['Líneas de Investigación', root_path],
#				['Investigadores Centro', root_path],
#				['Actividades Científicas Organizadas', root_path],
#				['Publicaciones', root_path],
#				['Propiedad Intelectual', root_path],
#				['Presentaciones Congresos', root_path],
#				['Premios y Honores', root_path]
			]
		end
	end

	def display_item_app(item, tipo_item)
		true
	end

end