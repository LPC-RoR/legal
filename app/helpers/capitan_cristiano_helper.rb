module CapitanCristianoHelper

	## ------------------------------------------------------- CRISTIANO BASE
	def cristiano(text, origen, destino)
		if ['AppAdministrador', 'app_administradores'].include?(text)
			'Administrador'
		elsif ['AppNomina', 'app_nominas'].include?(text)
			'Nómina'
		elsif ['AppPerfil', 'app_perfiles'].include?(text)
			'Perfil'
		elsif ['AppObservacion', 'app_observaciones'].include?(text)
			'Observación'
		elsif ['AppMejora', 'app_mejoras'].include?(text)
			'Mejora'
		elsif ['AppImagen', 'app_imagenes'].include?(text)
			'Imagen'
		elsif ['AppContacto', 'app_contactos'].include?(text)
			'Contacto'
		elsif ['AppMensaje', 'app_mensajes'].include?(text)
			'Mensaje'
		elsif ['AppDirectorio', 'app_directorios'].include?(text)
			'Directorio'
		elsif ['AppDocumento', 'app_documentos'].include?(text)
			'Documento'
		elsif ['HTema', 'h_temas'].include?(text)
			'Tema'
		elsif ['HLink', 'h_links'].include?(text)
			'Enlace'
		elsif ['HImagen', 'h_imagenes'].include?(text)
			'Imagen'
		elsif ['SbLista', 'sb_listas'].include?(text)
			'Menú lateral'
		elsif ['SbElemento', 'sb_elementos'].include?(text)
			'Elemento menú lateral'
		elsif ['HlpTutorial', 'hlp_tutoriales'].include?(text)
			'Tutorial'
		elsif ['HlpPaso', 'hlp_pasos'].include?(text)
			'Paso'
		elsif ['st_modelo', 'StModelo', 'st_modelos'].include?(text)
			'Modelo'
		elsif ['st_estado', 'StEstado', 'st_estados'].include?(text)
			'Estado'
		elsif ['created_at'].include?(text)
			'Fecha'
		else
			cristiano_app(text, origen, destino)
		end
	end

	def cristiano_app(text, origen, destino)
		if ['nombre_espaniol'].include?(text)
			'Nombre (Español)'
		else
			case origen
			when 'field'
				case destino
				when 'singular'
					text.humanize
				when 'plural'
				end
			when 'class'
				case destino
				when 'singular'
					text.tableize.humanize.singularize
				when 'plural'
					text.pluralize
				end
			when 'controller'
				case destino
				when 'singular'
					text.humanize.singularize
				when 'plural'
				end
			else
				text
			end
		end
	end

end