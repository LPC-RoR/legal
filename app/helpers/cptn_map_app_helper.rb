module CptnMapAppHelper

	## ------------------------------------------------------- GENERAL
	# desde controllers/concern/map
	# def app_bandeja_controllers

	def no_banner_display?
		controller_name == 'servicios' and action_name == 'aprobacion'
	end

	# DEPRECATED 	Ya NO usaré layouts, la idea es explorar pneles removibles
	def app_get_layout
		'General'
	end

	def app_sidebar_controllers
		[]
	end

	def app_controllers_scope
		{
			tarifas: ['tar_tarifas', 'tar_detalles', 'tar_valores', 'tar_servicios', 'tar_horas', 'tar_facturaciones', 'tar_uf_sistemas', 'tar_detalle_cuantias', 'tar_valor_cuantias', 'tar_pagos', 'tar_formulas', 'tar_comentarios', 'tar_uf_facturaciones', 'tar_aprobaciones', 'tar_facturas'],
			dt:      ['dt_materias', 'dt_infracciones', 'dt_multas', 'dt_tabla_multas', 'dt_criterio_multas']
		}
	end

	def app_scope_controller(controller)
		scope = nil
		app_controllers_scope.keys.each do |key_sym|
			scope = key_sym.to_s if app_controllers_scope[key_sym].include?(controller)
		end
		scope
	end

end