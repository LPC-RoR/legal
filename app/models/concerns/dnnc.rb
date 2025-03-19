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

 	# --------------------------------- ????

	def rgstrs_ok?
		self.krn_denunciantes.rgstrs_ok? and self.krn_denunciados.rgstrs_ok?
	end

	# ------------------------------------------------------------------------ PROC CNDTNS



	# ------------------------------------------------------------------------ PRTCPNTS

	# ------------------------------------------------------------------------ PRTCPNTS

	# Registros revisados
	def rlzds?
		self.krn_denunciantes.rlzds? and self.krn_denunciados.rlzds?
	end

	def evlds?
		self.evlcn_incmplt? or self.evlcn_incnsstnt? or self.evlcn_ok?
	end

	# ------------------------------------------------------------------------ DRVCNS

	# Responsable de investigar, usado en una nota solamente
	def responsable
		self.krn_derivaciones.empty? ? self.receptor_denuncia : self.krn_derivaciones.last.destino
	end

	# ------------------------------------------------------------------------ DRVCNS
	# REVISAR Está resuelto sin usar dt_obligatoria?

	def extrn_prsncl?
		self.rcp_empresa? and self.externa?
	end

	def riohs_off?
		false
	end

	def dt_obligatoria?
		self.extrn_prsncl? ? self.artcl41? : (self.riohs_off? or self.artcl41?)
	end

	# ------------------------------------------------------------------------ CIERRE

end