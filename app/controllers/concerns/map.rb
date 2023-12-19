module Map
	extend ActiveSupport::Concern

	## -------------------------------------------------------- BANDEJAS

	def bandeja_prefixs
		[]
	end

	def bandeja_prefixs?(controller)
		bandeja_prefixs.include?(controller.split('_')[0])
	end

	def app_bandeja_controllers
		['app_directorios', 'tar_detalles', 'tar_horas']
	end

	def bandeja_controllers
		base_bandeja_controllers = ['st_bandejas'].union(StModelo.where(bandeja: true).order(:st_modelo).map {|st_modelo| st_modelo.st_modelo.tableize}.compact)
		base_bandeja_controllers.union(app_bandeja_controllers)
	end

	def bandeja_display?
		bandeja_prefixs?(controller_name) or (controller_name == 'app_recursos' and action_name == 'tablas') or bandeja_controllers.include?(controller_name)
	end

	def init_bandejas
		if bandeja_display?
			if usuario_signed_in?
				# PRECAUCION @bandejas puede seu una lista de dos clases distintas
				if seguridad_desde('admin')
					@bandejas = StModelo.all.order(:st_modelo)
				elsif seguridad_desde('nomina')
					@bandejas = AppNomina.find_by(email: perfil_activo.email).st_perfil_modelos.order(:st_perfil_modelo)
				else
					@bandejas = nil
				end
#				@bandejas = (seguridad_desde('admin') ? StModelo.all.order(:st_modelo) : AppNomina.find_by(email: perfil_activo.email).st_perfil_modelos.order(:st_perfil_modelo))

				#inicializa despliegue
				unless @bandejas.empty?
					@m = params[:m].blank? ? @bandejas.first.modelo : params[:m]
					@e = (params[:e].blank? ? @bandejas.first.estados.first.estado : params[:e])
				else
					@m = nil
					@e = nil
				end
			end
		end
	end

end