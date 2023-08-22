module CptnConfigHelper
	def config
		{
			app: {
				nombre: 'addt',
				home: 'http://www.abogadosderechodeltrabajo.cl',
				logo_navbar: 'logo_legal.png'
			},
			layout: {
				menu_over: (not usuario_signed_in?),
				banner: true,
				menu: usuario_signed_in?,
			},
			container: {
				over: true,
				menu: true,
				body: true
			},
			color: {
				app: 'dark',
				navbar: 'light',
				navbar_bg: 'muted',
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
				portada: {clase: img_class[:centrada], size: nil},
				tema: {clase: img_class[:centrada], size: 'half'},
				foot: {clase: img_class[:centrada], size: 'quarter'}
			},
			font_size: {
				title: 4,
				title_tema: 1,
				detalle_tema: 6
			},
			decimales: {
				'Pesos' => Rails.configuration.decimales_pesos,
				'UF' => Rails.configuration.decimales_uf
			}
		}
	end

	def img_class 
		{
			centrada: 'mx-auto d-block'
		}
	end

end
