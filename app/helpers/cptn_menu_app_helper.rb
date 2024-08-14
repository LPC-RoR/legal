module CptnMenuAppHelper

	def navbar?
		{ a: false, s: false, h: true}
	end

	def menu_admn
	    []
	end

	def h_menu_admn
	    []
	end

	def s_menu_admn
	    []
	end

	# MENU del USUARIO REGISTRADO
	def menu
	    ## Menu principal de la aplicación
	    # [ 'Item del menú', 'link', {admin?, operacion?}, 'gly' ]
	    [
	    ]

	end

	def s_menu
	    []
	end
	def h_menu
	    []
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