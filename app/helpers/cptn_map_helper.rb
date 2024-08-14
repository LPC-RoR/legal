module CptnMapHelper

	def devise_controllers
		['confirmations', 'mailer', 'passwords', 'registrations', 'sessions', 'unlocks']
	end

	## ------------------------------------------------------- PARTIALS

	## Manejo de SCOPE de archivos
	def pick_scope(v_scope)
		if v_scope.blank?
			nil
		else
			case v_scope.length
			when 0
				nil
			when 1
				v_scope[0]
			else
				v_scope[0].split('/').length == 2 ? v_scope[0] : v_scope[1]
			end
		end
	end

	def with_scope(controller)
		if ['layouts', '0capitan', '0p'].include?(controller)
			controller
		else
			rutas = Rails.application.routes.routes.map {|route| route.defaults[:controller]}.uniq.compact
			scopes = rutas.map {|scope| scope if scope.split('/').include?(controller)}.compact
			pick_scope(scopes)
		end
	end

	def prtl_dir(controller, subdir)
		"#{with_scope(controller)}#{"/"+subdir unless subdir.blank?}/"
	end

	def prtl_name(controller, subdir, partial)
		"#{prtl_dir(controller, subdir)}#{partial}"
	end

	def prtl_to_file(prtl_nm)
		v_prtl = prtl_nm.split('/')
		v_prtl[v_prtl.length - 1] = "_#{v_prtl.last}"
		"app/views/#{v_prtl.join('/')}.html.erb"
	end

	def prtl?(controller, subdir, partial)
		File.exist?("app/views/#{prtl_dir(controller, subdir)}_#{partial}.html.erb")
	end

	def prtl_file?(file)
		File.exist?(file)
	end

	# ----------------------------------------------------------------- LAYOUT PARTIALS

	# alias de lyt partial
	def prtl_als
		{
			'layouts/devise/over' => 'layouts/home/over',
			'layouts/devise/main' => 'layouts/main',
		}
	end

	def lyt_prtl_dir
		if usuario_signed_in?
			controller_name == 'servicios' ? 'servicios' : nil
		else
			devise_controllers.include?(controller_name) ? 'devise' : 'home'
		end
	end

	def lyt_prtl(area)
		prtl_nm = prtl_name('layouts', lyt_prtl_dir, area)
		prtl_srch = prtl_als[prtl_nm].blank? ? prtl_nm : prtl_als[prtl_nm]
		prtl_file?(prtl_to_file(prtl_srch)) ? prtl_srch : nil
	end

	# Se usa para diferenciar Clases de Sass
	def lyts_prfx
		usuario_signed_in? ? (controller_name == 'servicios' ? 's' : 'a') : 'h'
	end

	# ----------------------------------------------------------------- TABLE PARTIALS

	# controlador SIN prefijo por alias
	def tbl_cntrllr(controller)
		simple = controller.split('-').last
		# app_alias in helper Cristiano
		app_alias[simple].blank? ? simple : app_alias[simple]
	end

	# source = {controller, objeto}
	def cntrllr(source)
		cntrllr = source.class.name == 'String' ? tbl_cntrllr(source) : source.class.name.tableize
	end

	# source = {controller, objeto}
	def objt_prtl(source)
		c = cntrllr(source)
		prtl?(c, 'list', 'lobjeto') ? 'lobjeto' : ( prtl?(c, 'list', 'objeto') ? 'objeto' : nil )
	end

	def objt_prtl_name(source)
		src_prtl = objt_prtl(source)
		c = cntrllr(source)
		src_prtl.blank? ? nil : prtl_name(c, 'list', src_prtl)
	end

	# ----------------------------------------------------------------- 

	## -------------------------------------------------------- BANDEJAS
	## EN REVISIÓN, se eliminó el uso de layouts, hay que revisar manejo de estados

	def primer_estado(controller)
		st_modelo = StModelo.find_by(st_modelo: controller.classify)
		st_modelo.blank? ? nil : st_modelo.primer_estado.st_estado
	end

	def estado_ingreso?(modelo, estado)
		st_modelo = StModelo.find_by(st_modelo: modelo)
		(st_modelo.blank? or st_modelo.st_estados.empty?) ? false : (st_modelo.st_estados.order(:orden).first.st_estado == estado)
	end

	def count_modelo_estado(modelo, estado)0
		modelo.constantize.where(estado: estado).count == 0 ? '' : "(#{modelo.constantize.where(estado: estado).count})"
	end

	## -------------------------------------------------------- TABLAS ORDENADAS

	def ordered_controllers
		['m_datos', 'm_elementos', 'sb_elementos', 'st_estados', 'tar_pagos', 'tar_formulas', 'tar_comentarios']
	end

	def ordered_controller?(controller)
		ordered_controllers.include?(controller)
	end

end