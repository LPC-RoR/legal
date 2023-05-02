module CptnAppMapHelper

	## ------------------------------------------------------- GENERAL
	# desde controllers/concern/map
	# def app_bandeja_controllers

	def app_get_layout
		'General'
	end

	def app_scope_controller(controller)
		if app_controllers_scope[:tarifas].include?(controller)
			'tarifas'
		end
	end

end