module Bandejas
	extend ActiveSupport::Concern

	def bandeja_controller?(controller)
		admin_controllers.exclude?(controller) and devise_controllers.exclude?(controller)
	end

	def init_bandejas
		unless admin_controller?(controller_name)
			
			if usuario_signed_in?
				# PRECAUCION @bandejas puede seu una lista de dos clases distintas
				@bandejas = (seguridad_desde('admin') ? StModelo.all.order(:st_modelo) : AppNomina.find_by(email: perfil_activo.email).st_perfil_modelos.order(:st_perfil_modelo))

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