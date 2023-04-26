module CptnAppConfigHelper
	def config
		{
			app: {
				nombre: 'Legal',
				home: 'http://www.abogadosderechodeltrabajo.cl',
				logo_navbar: 'logo_menu.png'
			},
			color: {
				app: 'dark',
				navbar: 'dark',
				help: 'dark',
				data: 'success',
				title_tema: 'primary',
				detalle_tema: 'primary'
			},	
			menu: {
				dd_enlaces: true,
				contacto: true,
				ayuda: true,
				recursos: false	# está en capitan/drop_down/_ddown_principal.html.erb REVISAR
			},
			image: {
				portada: {clase: ctes[:image][:centrada], size: nil},
				tema: {clase: ctes[:image][:centrada], size: 'half'},
				foot: {clase: ctes[:image][:centrada], size: 'quarter'}
			},
			font_size: {
				title: 4,
				title_tema: 1,
				detalle_tema: 6
			}
		}
	end
end
