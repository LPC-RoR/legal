module CptnHelper
	## ------------------------------------------------------- SCOPES & PARTIALS

	def controllers_scope
		{
			aplicacion:    ['app_recursos'],
			autenticacion: ['app_administradores', 'app_nominas', 'app_perfiles'],
			recursos:      ['app_contactos', 'app_enlaces', 'app_mejoras', 'app_mensajes', 'app_observaciones'],
			repositorios:  ['app_repos', 'app_directorios', 'app_documentos', 'app_archivos', 'app_imagenes'],
			home:          ['h_temas', 'h_links', 'h_imagenes'],
			help:          ['conversaciones', 'mensajes', 'hlp_pasos', 'temaf_ayudas', 'hlp_tutoriales'],
			sidebar:       ['sb_listas', 'sb_elementos'],
			busqueda:      ['ind_clave_facetas', 'ind_claves', 'ind_indice_facetas', 'ind_indices', 'ind_palabras', 'ind_reglas', 'ind_sets'],
			estados:       ['st_modelos', 'st_estados'],
			data:          ['caracteristicas', 'caracterizaciones', 'columnas', 'datos', 'encabezados', 'etapas', 'lineas', 'opciones', 'tablas']
		}
	end

	def scope_controller(controller)
		if controllers_scope[:aplicacion].include?(controller)
			'aplicacion'
		elsif controllers_scope[:autenticacion].include?(controller)
			'autenticacion'
		elsif controllers_scope[:recursos].include?(controller)
			'recursos'
		elsif controllers_scope[:repositorios].include?(controller)
			'repositorios'
		elsif controllers_scope[:home].include?(controller)
			'home'
		elsif controllers_scope[:help].include?(controller)
			'help'
		elsif controllers_scope[:sidebar].include?(controller)
			'sidebar'
		elsif controllers_scope[:busqueda].include?(controller)
			'busqueda'
		elsif controllers_scope[:estados].include?(controller)
			'estados'
		elsif controllers_scope[:data].include?(controller)
			'data'
		else
			app_scope_controller(controller)
		end
	end

end
