module CptnLayoutsHelper
	# Helper para el manejo de los layouts de la aplicación

	def devise_controllers
		['confirmations', 'mailer', 'passwords', 'registrations', 'sessions', 'unlocks']
	end

	def devise_routes?
		devise_controllers.include?(controller_name)
	end

	def public_controller_routes?
		['hlp_ayudas', 'servicios'].include?(controller_name)
	end

	def blg_routes?
		controller_name == 'home' and action_name == 'artcls'
	end

	def non_left_menu_controllers
		devise_controllers | public_controller_routes? | ['cuentas'] | blg_routes?
	end

	# helper_method : rutas que NO requieren autenticación de usuarios
	def not_authenticate_routes?
		public_home = (controller_name == 'home' and ['index', 'costos', 'artcls'].include?(action_name))
		public_controller_routes? or devise_routes? or public_home | blg_routes?
	end

	def krn_non_krn_routes?
		['app_nominas', 'app_contactos', 'act_archivos', 'rep_archivos', 'notas', 'pdf_archivos', 'empresas'].include?(controller_name) and ['edit', 'new'].include?(action_name)
	end

	def cuentas_routes?
		['cuentas'].include?(controller_name)and ['dnncs', 'invstgdrs', 'extrns', 'nmn'].include?(action_name)
	end

	def krn_hlp_routes?
		(controller_name == 'hlp_ayudas' and ['ambnt', 'bnvnd', 'dcmntcn_oblgtr', 'dnnc_smpl', 'drchs_rspnsbldds', 'estrctr_dnnc', 'prcdmnt_invstgcn_sncn', 'prncpl_usr', 'rgstr_emprs', 'rprts_ntfccns'].include?(@hlp))
	end

	def krn_routes?
		controller_name.start_with?('krn_') or cuentas_routes? or krn_non_krn_routes? or krn_hlp_routes? or devise_routes? or blg_routes?
	end

	# Resuelve el directorio donde encontrar el layout
	def lyt_prtl_dir
		if public_controller_routes? or devise_routes? or (controller_name == 'home' and ['index', 'costos', 'artcls'].include?(action_name))
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