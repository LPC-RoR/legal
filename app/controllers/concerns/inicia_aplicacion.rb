module IniciaAplicacion
	extend ActiveSupport::Concern

	def set_tablas_base
		
		# VERIFICA QUE TABLAS Y REGISTROS MINIMOS ESTÉN PRESENTES Y MIGRADOS SI CORRESPONDE
		# SB_ADMINISTRACION

		# SB_LISTAS

		if ActiveRecord::Base.connection.table_exists? 'sb_listas'

			# LISTA ADMINISTRACION
			lista = SbLista.find_by(lista: 'Administración')
			if lista.blank?
				lista = SbLista.create(lista: 'Administración', acceso: 'admin', link: '/app_recursos/administracion')
			end

			if ActiveRecord::Base.connection.table_exists? 'sb_elementos'
				elementos = lista.sb_elementos

				e_1 = elementos.find_by(elemento: 'Administradores')
				if e_1.blank?
					lista.sb_elementos.create(orden: 1, nivel: 1, tipo: 'item', elemento: 'Administradores', acceso: 'admin', activo: true, despliegue: 'list', controlador: 'app_administradores')
				end

				e_2 = elementos.find_by(elemento: 'Nómina')
				if e_2.blank?
					lista.sb_elementos.create(orden: 2, nivel: 1, tipo: 'item', elemento: 'Nómina', acceso: 'admin', activo: true, despliegue: 'list', controlador: 'app_nominas')
				end

				e_3 = elementos.find_by(elemento: 'Perfiles')
				if e_3.blank?
					lista.sb_elementos.create(orden: 3, nivel: 1, tipo: 'item', elemento: 'Perfiles', acceso: 'admin', activo: true, despliegue: 'list', controlador: 'app_perfiles')
				end

				e_4 = elementos.find_by(elemento: 'Menús Laterales')
				if e_4.blank?
					lista.sb_elementos.create(orden: 4, nivel: 1, tipo: 'item', elemento: 'Menús Laterales', acceso: 'admin', activo: true, despliegue: 'list', controlador: 'sb_listas')
				end

				e_5 = elementos.find_by(elemento: 'Tutoriales')
				if e_5.blank?
					lista.sb_elementos.create(orden: 5, nivel: 1, tipo: 'item', elemento: 'Tutoriales', acceso: 'admin', activo: true, despliegue: 'list', controlador: 'hlp_tutoriales')
				end

				e_6 = elementos.find_by(elemento: 'Usuarios')
				if e_6.blank?
					lista.sb_elementos.create(orden: 6, nivel: 1, tipo: 'item', elemento: 'Usuarios', acceso: 'admin', activo: true, despliegue: 'list', controlador: 'usuarios')
				end

				e_7 = elementos.find_by(elemento: 'Home')
				if e_7.blank?
					lista.sb_elementos.create(orden: 7, nivel: 1, tipo: 'list', elemento: 'Home', acceso: 'admin', activo: true, despliegue: nil, controlador: nil)
				end

				e_8 = elementos.find_by(elemento: 'Imágenes')
				if e_8.blank?
					lista.sb_elementos.create(orden: 8, nivel: 2, tipo: 'item', elemento: 'Imágenes', acceso: 'admin', activo: true, despliegue: 'list', controlador: 'h_imagenes')
				end

				e_9 = elementos.find_by(elemento: 'Temas')
				if e_9.blank?
					lista.sb_elementos.create(orden: 9, nivel: 2, tipo: 'item', elemento: 'Temas', acceso: 'admin', activo: true, despliegue: 'list', controlador: 'h_temas')
				end

				e_8 = elementos.find_by(elemento: 'Enlaces')
				if e_8.blank?
					lista.sb_elementos.create(orden: 10, nivel: 2, tipo: 'item', elemento: 'Enlaces', acceso: 'admin', activo: true, despliegue: 'list', controlador: 'h_links')
				end
			end

			# LISTA AYUDA
			ayuda = SbLista.find_by(lista: 'Ayuda')
			if ayuda.blank?
				ayuda = SbLista.create(lista: 'Ayuda', acceso: 'admin', link: '/recursos/ayuda')
			end
		end		

		# APP_ADMINISTRADORES SIN _IDS QUE MIGRAR

		if ActiveRecord::Base.connection.table_exists? 'app_administradores'
			# DOG
			dog = AppAdministrador.find_by(email: dog_email)
			if dog.blank?
				AppAdministrador.create(administrador: dog_name, email: dog_email)
			end

			if AppAdministrador.all.empty?
				if ActiveRecord::Base.connection.table_exists? 'administradores'
					Administrador.all.each do |adm|
						app_adm = AppAdministrador.find_by(email: adm.email)
						if app_adm.blank?
							AppAdministrador.create(administrador: adm.administrador, email: adm.email)
						end
					end
				end
			end
		end
		
		# APP_NOMINAS SIN _IDS QUE MIGRAR

		if ActiveRecord::Base.connection.table_exists? 'app_nominas'
			if AppNomina.all.empty?
				if ActiveRecord::Base.connection.table_exists? 'nominas'
					Nomina.all.each do |nom|
						app_nom = AppNomina.find_by(email: nom.email)
						if app_nom.blank?
							AppNomina.create(nombre: nom.nombre, email: nom.email, tipo: nom.tipo)
						end
					end
				end
			end
		end

		# APP_PERFILES

		if ActiveRecord::Base.connection.table_exists? 'app_perfiles'
			if AppPerfil.all.empty?
				if ActiveRecord::Base.connection.table_exists? 'perfiles'
					Perfil.all.each do |per|
						app_perfil = AppPerfil.find_by(email: per.email)
						if app_perfil.blank?
							app_perfil = AppPerfil.create(usuario_id: current_usuario.id, email: per.email)
							administrador = AppAdministrador.find_by(email: per.email)
							if administrador.present?
								app_perfil.app_administrador = administrador
								app_perfil.save
							end
						end
						# se migran las CARPETAS
#						per.carpetas.each do |car|
#							car.app_perfil_id = app_perfil.id
#							car.save
#						end
					end
				end
			end
		end

		# HLP_TUTORIALES

		if ActiveRecord::Base.connection.table_exists? 'hlp_tutoriales'
			if HlpTutorial.all.empty?
				if ActiveRecord::Base.connection.table_exists? 'tutoriales'
					Tutorial.all.each do |tut|
						app_tut = HlpTutorial.find_by(tutorial: tut.tutorial)
						if app_tut.blank?
							app_tut = HlpTutorial.create(tutorial: tut.tutorial, detalle: tut.detalle)
						end

						tut.pasos.each do |paso|
							app_tut.hlp_pasos.create(orden: paso.orden, paso: paso.paso, detalle: paso.detalle)
						end
					end
				end
			end
		end

	end

	def libre_registro
		false
	end

	def inicia_app
	end

end