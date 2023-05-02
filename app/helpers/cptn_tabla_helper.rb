module CptnTablaHelper

#********************************************************************** GENERAL *************************************************************
	def no_th_controllers
		['directorios', 'documentos', 'archivos', 'imagenes'] + app_no_th_controllers
	end

	# ADMIN AREA
	# condiciones bajo las cuales se despliega una tabla
	def new_button_conditions(controller)
		if controller_name == 'st_bandejas'
			# en las bandejas sólo se dedspliega para el primer estado del modelo
			false
		else
			case controller

			when 'perfil-app_enlaces'
				false
			else
				aliasness = get_controller(controller)
				if ['app_administradores', 'app_nominas', 'hlp_tutoriales', 'hlp_pasos'].include?(aliasness)
						seguridad_desde('admin')
				elsif ['app_perfiles', 'usuarios', 'ind_palabras', 'app_contactos', 'app_directorios', 'app_documentos', 'app_archivos', 'app_enlaces'].include?(controller)
					false
				elsif ['app_mensajes'].include?(aliasness)
					action_name == 'index' and @e == 'ingreso'
				elsif ['sb_listas'].include?(aliasness)
						seguridad_desde('admin')
				elsif ['sb_elementos'].include?(aliasness)
						(@objeto.acceso == 'dog' ? dog? : seguridad_desde('admin'))
				elsif ['st_modelos'].include?(aliasness)
						dog?
				elsif ['st_estados'].include?(aliasness)
						seguridad_desde('admin')
				else
					app_new_button_conditions(controller)
				end
			end
		end
	end

	# Objtiene LINK DEL BOTON NEW
	def get_new_link(controller)
		# distingue cuando la tabla está en un index o en un show
		(controller_name == get_controller(controller) or @objeto.blank?) ? "/#{get_controller(controller)}/new" : "/#{@objeto.class.name.tableize}/#{@objeto.id}/#{get_controller(controller)}/new"
	end

	def crud_conditions(objeto, btn)
		if ['AppAdministrador', 'AppNomina', 'HlpTutorial', 'HlpPaso'].include?(objeto.class.name)
				seguridad_desde('admin')
		elsif ['AppPerfil', 'Usuario', 'AppMensaje' ].include?(objeto.class.name)
			false
		elsif ['SbLista', 'SbElemento'].include?(objeto.class.name)
			(usuario_signed_in? and seguridad_desde(objeto.acceso))
		elsif ['st_modelos'].include?(controller)
				dog?
		elsif ['st_estados'].include?(controller)
				seguridad_desde('admin')
		elsif ['AppObservacion', 'AppMejora'].include?(objeto.class.name)
			(usuario_signed_in? and objeto.app_perfil.id == current_usuario.id)
		else
			app_crud_conditions(objeto, btn)
		end
	end

#**********************************************************************   APP   *************************************************************

	def app_no_th_controllers
		[]
	end

	def app_new_button_conditions(controller)
		if ['tar_tarifas', 'tar_servicios', 'tar_valores', 'tar_horas', 'registros', 'reg_reportes', 'tar_facturaciones', 'tar_valor_cuantias', 'tar_facturas'].include?(controller)
			false
		elsif ['causas', 'consultorias'].include?(controller)
			controller_name == 'st_bandejas'
		else
			true
		end
	end

	def app_crud_conditions(objeto, btn)
		if [].include?(objeto.class.name)
			admin?
		elsif ['TarFacturacion', 'TarFactura'].include?(objeto.class.name)
			false
		elsif ['TarPago', 'TarFormula'].include?(objeto.class.name)
			controller_name == 'tar_tarifas'
		else
			case objeto.class.name
			when 'TarValorCuantia'
				controller_name == 'causas' and @options[:menu] == 'Cuantía'
			when 'Registro'
				admin? and objeto.estado == 'ingreso'
			when 'RegReporte'
				false
			else
				true
			end
		end
	end

end