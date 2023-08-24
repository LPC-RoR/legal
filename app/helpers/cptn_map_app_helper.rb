module CptnMapAppHelper

	## ------------------------------------------------------- GENERAL
	# desde controllers/concern/map
	# def app_bandeja_controllers

	def no_banner_display?
		controller_name == 'app_recursos' and action_name == 'aprobacion'
	end

	def app_get_layout
		'General'
	end

	def app_sidebar_controllers
		[]
	end

	def app_controllers_scope
		{
			tarifas: ['tar_tarifas', 'tar_detalles', 'tar_valores', 'tar_servicios', 'tar_horas', 'tar_facturaciones', 'tar_uf_sistemas', 'tar_detalle_cuantias', 'tar_valor_cuantias', 'tar_pagos', 'tar_formulas', 'tar_comentarios', 'tar_uf_facturaciones', 'tar_aprobaciones']
		}
	end

	def app_scope_controller(controller)
		if app_controllers_scope[:tarifas].include?(controller)
			'tarifas'
		end
	end

end