module CptnConfigHelper
	def config
		{
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
		}
	end

	def img_class 
		{
			centrada: 'mx-auto d-block'
		}
	end

	# CONFIG con MANEJO DE DEFAULT VALUES

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

	def get_cfg(cfg_nombre)
		cfg = version_activa.cfg_valores.find_by(cfg_valor: cfg_nombre)
		if cfg.blank?
			cfg_defaults[cfg_nombre.to_sym]
		else
			case cfg.tipo
			when 'palabra'
				cfg.palabra
			when 'numero'
				cfg.numero
			when 'texto'
				cfg.texto
			when 'fecha'
				cfg.fecha
			when 'fecha_hora'
				cfg.fecha_hora
			when 'condicion'
				cfg.condicion
			end
		end
	end

	def app_nombre
		get_cfg('app_nombre')
	end

	def app_sigla
		get_cfg('app_sigla')
	end

	def app_home
		get_cfg('app_home')
	end

	def lyt_o_menu
		get_cfg('lyt_o_menu')
	end

	def lyt_o_bann
		get_cfg('lyt_o_bann')
	end

	def lyt_navbar
		get_cfg('lyt_navbar')
	end

	def lyt_o_menu_padd
		get_cfg('lyt_o_menu_padd')
	end

	def lyt_o_bann_padd
		get_cfg('lyt_o_bann_padd')
	end

	def lyt_navbar_padd
		get_cfg('lyt_navbar_padd')
	end

	def lyt_body_padd
		get_cfg('lyt_body_padd')
	end

end
