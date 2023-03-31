module Bandejas
	def init_bandejas
		if usuario_signed_in?
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