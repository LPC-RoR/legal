module Prtcpnts
	extend ActiveSupport::Concern

	# app/controllers/karin/krn_denunciantes_controller.rb (y análogos)
	def anonimizar_dclrcn
	  objeto = KrnDenunciante.find(params[:id])
	  if objeto.anonimizar_dclrcn!
	    redirect_to "/krn_denuncias/#{objeto.dnnc.id}_4",
	                notice: "Declaración de #{objeto.nombre} anonimizada."
	  else
	    redirect_to "/krn_denuncias/#{objeto.dnnc.id}_4",
	                alert: "No se pudo anonimizar (¿falta la declaración original?)."
	  end
	end

end