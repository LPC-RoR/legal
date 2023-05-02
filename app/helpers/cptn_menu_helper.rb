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
		if perfil? == true
			if ['dog', 'admin', 'anonimo'].include?(tipo_item)
				(usuario_signed_in? and seguridad_desde(tipo_item))
			elsif ['nomina', 'general'].include?(tipo_item)
				(usuario_signed_in? and seguridad_desde(tipo_item) and display_item_app(item, tipo_item))
			elsif tipo_item == 'excluir'
				false
			end
		else
			tipo_item == 'anonimo'
		end
	end

	def enlaces_generales
		AppEnlace.where(owner_id: nil).order(:descripcion)
	end

	def enlaces_perfil
		AppEnlace.where(owner_class: 'AppPerfil', owner_id: perfil_activo.id).order(:descripcion)
	end

end