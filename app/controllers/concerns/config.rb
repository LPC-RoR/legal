module Config
	extend ActiveSupport::Concern

	def cfg_defaults
		{
			app_nombre: 'Abogados Derecho del Trabajo',
			app_sigla: 'addt',
			app_home: "http://www.abogadosderechodeltrabajo.cl/",
			activa_tipos_usuario: true,
			# Determinan la existencia de elementos del layout
			lyt_o_menu: true,
			lyt_o_bann: true,
			lyt_navbar: false,
			# Padding de los elementos del layout
			lyt_o_menu_padd: 3,
			lyt_o_bann_padd: 3,
			lyt_navbar_padd: 3,
			lyt_body_padd: 3,
			# Número de decimales
			pesos: 0,
			uf: 2,
			uf_calculo: 5,
			porcentaje: 2
		}
	end

	def cfg_navbar
		{
			color: 'info',
			logo_navbar: nil,
#			logo_navbar: 'logo_navbar.gif',
			bg_color: '#45b39d'
		}
	end

	def cfg_color
		{
			app: 'dark',
			navbar: 'light',
			navbar_bg: 'muted',
			help: 'dark',
			data: 'success',
		}
	end

	def cfg_fonts
		{
			size_title: 4
		}
	end

end