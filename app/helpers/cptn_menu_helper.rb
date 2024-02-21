module CptnMenuHelper
	## ------------------------------------------------------- MENU

	# Obtiene los controladores que no despliegan menu
	def nomenu?(controller)
		nomenu_controllers = ['confirmations', 'mailer', 'passwords', 'registrations', 'sessions', 'unlocks']
		nomenu_controllers.include?(controller)
	end

	def item_active(link)
		detalle_link = link.split('/')
		nombre_accion = (detalle_link.length == 2 ? 'index' : detalle_link[2])
		detalle_link[1] == controller_name and nombre_accion == action_name
	end

	def display_item_menu?(item, tipo_item)
		# SEGURIDADA PARA IEMS DE MENÚS
		if perfil_activo? == true
			seguridad(tipo_item)
		else
			tipo_item == 'anonimo'
		end
	end

end