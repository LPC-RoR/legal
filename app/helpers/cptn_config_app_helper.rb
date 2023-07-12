module CptnConfigAppHelper
	def config
		{
			app: {
				nombre: 'Legal',
				home: 'http://www.abogadosderechodeltrabajo.cl',
				logo_navbar: 'logo.png'
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
