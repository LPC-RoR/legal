module Dnnc
 	extend ActiveSupport::Concern

 	# ================================= GENERAL
 	# --------------------------------- Asociaciones

 	def denunciantes?
 		self.krn_denunciantes.any?
 	end

 	def denunciados?
 		self.krn_denunciados.any?
 	end

 	def declaraciones?
 		self.krn_declaraciones.any?
 	end

 	def derivaciones?
 		self.krn_derivaciones.any?
 	end

 	def investigadores?
 		self.krn_inv_denuncias.any?
 	end

	# ------------------------------------------------------------------------ PRTCPNTS

	# Registros revisados
	def dclrcns?
		self.krn_denunciantes.dclrcns? and (self.krn_denunciados.dclrcns? or self.motivo_vlnc?)
	end

end