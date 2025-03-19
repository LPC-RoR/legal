module Dnnc
 	extend ActiveSupport::Concern

 	# ================================= GENERAL
 	# --------------------------------- Despliegue de formularios
	def css_id
		'dnnc'
	end

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

	def rgstrs_ok?
		self.krn_denunciantes.rgstrs_ok? and self.krn_denunciados.rgstrs_ok?
	end

	# Registros revisados
	def rlzds?
		self.krn_denunciantes.rlzds? and self.krn_denunciados.rlzds?
	end

	def evlds?
		self.evlcn_incmplt? or self.evlcn_incnsstnt? or self.evlcn_ok?
	end

	# ------------------------------------------------------------------------ DRVCNS

	def extrn_prsncl?
		self.rcp_empresa? and self.externa?
	end


end