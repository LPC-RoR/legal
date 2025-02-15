module CptnMapHelper

	def devise_controllers
		['confirmations', 'mailer', 'passwords', 'registrations', 'sessions', 'unlocks']
	end

	#------------------------------------------------------------------ PARTIALS

	# Obtiene el cntrllr cuando tiene prefijo
	def prfx_cntrllr(cntrllr)
		cntrllr.match(/\-/) ? cntrllr.split('-').first : nil
	end

	# Obtiene el prefijo si lo hay
	def prfx_prtl(cntrllr, prtl)
		prfx = prfx_cntrllr(cntrllr)
		"#{"#{prfx}-" unless prfx.blank?}#{prtl}"
	end

	# source = {controller, objeto}
	def cntrllr(source)
		if source.class.name == 'String'
			prfx_cntrllr = source.split('-').last
			# app_alias in helper Cristiano
			app_alias[prfx_cntrllr].blank? ? prfx_cntrllr : app_alias[prfx_cntrllr]
		else
			source.class.name.tableize
		end
	end

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
		if ['layouts', '0capitan', '0p', 'repositorios', 'karin'].include?(controller)
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
		"#{prtl_dir(cntrllr(controller), subdir)}#{prfx_prtl(controller, partial)}"
	end

	def prtl_to_file(prtl_nm)
		v_prtl = prtl_nm.split('/')
		v_prtl[v_prtl.length - 1] = "_#{v_prtl.last}"
		"app/views/#{v_prtl.join('/')}.html.erb"
	end

	def prtl?(controller, subdir, partial)
		File.exist?("app/views/#{prtl_dir(cntrllr(controller), subdir)}_#{prfx_prtl(controller, partial)}.html.erb")
	end

	def prtl_file?(file)
		File.exist?(file)
	end

	# ----------------------------------------------------------------- SCOPE PARTIALS

	def scp_prtl(scp, dir, prtl)
		"#{scp}/#{dir+'/' unless dir.blank?}#{prtl}"
	end

	def scp_prtl?(scp, dir, prtl)
		prtl_file?(prtl_to_file(scp_prtl(scp, dir, prtl)))
	end

	# ----------------------------------------------------------------- LAYOUT PARTIALS

	# Esta función nos lleva al directorio donde se encuentran los layouts ocupados
	def lyt_prtl_dir
		if usuario_signed_in?
			controller_name == 'servicios' ? 'servicios' : nil
		else
			devise_controllers.include?(controller_name) ? 'devise' : 'home'
		end
	end

	def lyt_prtl(area)
		prtl?('layouts', lyt_prtl_dir, area) ? prtl_name('layouts', lyt_prtl_dir, area) : ( prtl?('layouts', nil, area) ? prtl_name('layouts', nil, area) : nil )
	end

	# Se usa para diferenciar Clases de Sass
	def lyts_prfx
		usuario_signed_in? ? (controller_name == 'servicios' ? 's' : 'a') : 'h'
	end

	# ----------------------------------------------------------------- TABLE PARTIALS

	def ownr_prms(objeto)
		"?oclss=#{objeto.class.name}&oid=#{objeto.id}"
	end

	def blngs_prms(objeto)
		"?oid=#{objeto.id}"
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

	def count_modelo_estado(modelo, estado)0
		modelo.constantize.where(estado: estado).count == 0 ? '' : "(#{modelo.constantize.where(estado: estado).count})"
	end

	## -------------------------------------------------------- TABLAS ORDENADAS

	def ordered_controllers
		['m_datos', 'm_elementos', 'st_estados', 'tar_pagos', 'tar_formulas', 'tar_comentarios']
	end

	def ordered_controller?(controller)
		ordered_controllers.include?(controller)
	end

end