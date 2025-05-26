module CptnLayoutsHelper
	# Helper para el manejo de los layouts de la aplicación

	def devise_controllers
		['confirmations', 'mailer', 'passwords', 'registrations', 'sessions', 'unlocks']
	end

	def public_controllers
		['hlp_ayudas']
	end

	def non_left_menu_controllers
		devise_controllers | public_controllers | ['cuentas']
	end

	# helper_method : rutas que NO requieren autenticación de usuarios
	def not_authenticate_routes?
		public_home = action_name == 'home' and (not usuario_signed_in?)
		(public_controllers | devise_controllers).include?(controller_name) or (public_home)
	end

	def krn_non_krn_routes?
		['app_nominas', 'app_contactos', 'rep_archivos', 'notas', 'pdf_archivos'].include?(controller_name) and ['edit', 'new'].include?(action_name)
	end

	def cuentas_routes?
		['cuentas'].include?(controller_name)and ['dnncs', 'invstgdrs', 'extrns', 'nmn'].include?(action_name)
	end

	def krn_routes?
		controller_name.start_with?('krn_') or cuentas_routes? or krn_non_krn_routes?
	end

	def krn_user_error?
		get_scp_activo.present? and (not (krn_routes? or not_authenticate_routes?))
	end

	# Esta función nos lleva al directorio donde se encuentran los layouts ocupados
	def lyt_prtl_dir
		if controller_name == 'hlp_ayudas'
			'home'
		else
			if usuario_signed_in?
				controller_name == 'servicios' ? 'servicios' : nil
			else
				devise_controllers.include?(controller_name) ? 'devise' : 'home'
			end
		end
	end

	def lyt_prtl(area)
		dir_prtl = prtl?('layouts', lyt_prtl_dir, area)
		prtl?('layouts', lyt_prtl_dir, area) ? prtl_name('layouts', lyt_prtl_dir, area) : ( prtl?('layouts', nil, area) ? prtl_name('layouts', nil, area) : nil )
	end

end