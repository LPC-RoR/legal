module CptnMapHelper

	def devise_controllers
		['confirmations', 'mailer', 'passwords', 'registrations', 'sessions', 'unlocks']
	end

	## ------------------------------------------------------- PARTIALS

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
			#coincidencias = Rails.application.routes.routes.map do |route|
			#  route.defaults[:controller]
			#end.uniq.compact.map {|scope| scope if scope.split('/').include?(controller)}.compact
		end
		pick_scope(scopes)
	end

	# actual, se usa para no repetir código del subdirectorio
	def partial_dir(controller, subdir)
		"#{with_scope(controller)}#{"/"+subdir unless subdir.blank?}/"
	end

	# nombre del patial SIN underscore
	# antiguo 'get_partial'
	def partial_name(controller, subdir, partial)
		"#{partial_dir(controller, subdir)}#{partial}"
	end

	# Este helper pergunta si hay un partial con un nombre particular en el directorio del controlador
	# tipo: {nil='controlador', 'partials', (ruta-adicional)}
	def partial?(controller, subdir, partial)
		File.exist?("app/views/#{partial_dir(controller, subdir)}_#{partial}.html.erb")
	end

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