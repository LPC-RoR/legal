module Config
	extend ActiveSupport::Concern

	def cfg_defaults
		{
			app_nombre: 'Laborsafe',
			app_sigla: 'addt',
			app_home: "https://www.laborsafe.cl/",
			activa_tipos_usuario: true,
			# Determinan la existencia de elementos del layout
			lyt_o_bann: true,
			lyt_navbar: false,
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
			logo_navbar: 'logo_navbar.png',
#			logo_navbar: 'logo_navbar.gif',
			bg_color: '#023047'
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