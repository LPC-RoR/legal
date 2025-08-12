module CptnLayoutsHelper
	# Helper para el manejo de los layouts de la aplicación

	def devise_controllers
		['confirmations', 'mailer', 'passwords', 'registrations', 'sessions', 'unlocks']
	end

	def devise_routes?
		devise_controllers.include?(controller_name)
	end

	def public_controllers
		['hlp_ayudas']
	end

	def non_left_menu_controllers
		devise_controllers | public_controllers | ['cuentas']
	end

	# helper_method : rutas que NO requieren autenticación de usuarios
	def not_authenticate_routes?
		public_home = (controller_name == 'home' and ['index', 'costos'].include?(action_name))
		(public_controllers | devise_controllers).include?(controller_name) or public_home
	end

	def krn_non_krn_routes?
		['app_nominas', 'app_contactos', 'rep_archivos', 'notas', 'pdf_archivos', 'rcrs_logos'].include?(controller_name) and ['edit', 'new'].include?(action_name)
	end

	def cuentas_routes?
		['cuentas'].include?(controller_name)and ['dnncs', 'invstgdrs', 'extrns', 'nmn'].include?(action_name)
	end

	def krn_hlp_routes?
		(controller_name == 'hlp_ayudas' and ['ambnt', 'bnvnd', 'dcmntcn_oblgtr', 'dnnc_smpl', 'drchs_rspnsbldds', 'estrctr_dnnc', 'prcdmnt_invstgcn_sncn', 'prncpl_usr', 'rgstr_emprs', 'rprts_ntfccns'].include?(@hlp))
	end

	def krn_routes?
		controller_name.start_with?('krn_') or cuentas_routes? or krn_non_krn_routes? or krn_hlp_routes? or devise_routes?
	end

	def krn_user_error?
		get_scp_activo.present? and (not (krn_routes? or not_authenticate_routes?))
	end

	# Resuelve el directorio donde encontrar el layout
	def lyt_prtl_dir
		if ['hlp_ayudas', 'servicios'].include?(controller_name) or devise_controllers.include?(controller_name) or (controller_name == 'home' and ['index', 'costos'].include?(action_name))
			'home'
		else
			nil
		end
	end

	# Resuelve el layout que ocupar
	# Usa por defecto el que está en la raiz
	def lyt_prtl(area)
		prtl?('layouts', lyt_prtl_dir, area) ? prtl_name('layouts', lyt_prtl_dir, area) : ( prtl?('layouts', nil, area) ? prtl_name('layouts', nil, area) : nil )
	end

end