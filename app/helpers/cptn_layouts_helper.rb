module CptnLayoutsHelper
	# Helper para el manejo de los layouts de la aplicación

	def devise_controllers
		['confirmations', 'mailer', 'passwords', 'registrations', 'sessions', 'unlocks']
	end

	def public_controllers
		['publicos']
	end

	def non_left_menu_controllers
		devise_controllers | public_controllers | ['cuentas']
	end

	# helper_method : rutas que NO requieren autenticación de usuarios
	def not_authenticate_routes?
		authenticate_home = action_name == 'home' and usuario_signed_in?
		(public_controllers | devise_controllers).include?(controller_name) and (not authenticate_home)
	end

	def krn_non_krn_routes?
		['app_nominas', 'rep_archivos', 'notas'].include?(controller_name) and ['edit', 'new'].include?(action_name)
	end

	def cuentas_routes?
		['cuentas'].include?(controller_name)and ['dnncs', 'invstgdrs', 'extrns', 'nmn'].include?(action_name)
	end

	def new_krn_routes?
		controller_name.start_with?('krn_') or cuentas_routes? or krn_non_krn_routes?
	end

	def krn_routes?
		!!(controller_name =~ /^krn_[a-z_]*$/) or krn_non_krn_routes?
	end

	def krn_user_error?
		get_scp_activo.present? and (not krn_routes?)
	end

	# Esta función nos lleva al directorio donde se encuentran los layouts ocupados
	def lyt_prtl_dir
		if usuario_signed_in?
			controller_name == 'servicios' ? 'servicios' : nil
		else
			devise_controllers.include?(controller_name) ? 'devise' : 'home'
		end
	end

	def lyt_prtl(area)
		dir_prtl = prtl?('layouts', lyt_prtl_dir, area)
		prtl?('layouts', lyt_prtl_dir, area) ? prtl_name('layouts', lyt_prtl_dir, area) : ( prtl?('layouts', nil, area) ? prtl_name('layouts', nil, area) : nil )
	end

end