module Dnnc
 	extend ActiveSupport::Concern

	PRESENTADORES = ['Denunciante', 'Representante']

	def css_id
		'dnnc'
	end

	# ------------------------------------------------------------------------ INGRS

	def rprsntnt?
		self.presentado_por == KrnDenuncia::TIPOS_DENUNCIANTE[1]
	end

	def rgstrs_ok?
		self.krn_denunciantes.rgstrs_ok? and self.krn_denunciados.rgstrs_ok?
	end

	# ------------------------------------------------------------------------ PRTCPNTS


	def prtcpnts?
		self.no_vlnc? ? (self.dnncnts? and self.dnncds?) : self.dnncnts?
	end

	# ------------------------------------------------------------------------ DRVCNS

	def extrn_prsncl?
		self.rcp_empresa? and self.externa?
	end

	def riohs_off?
		false
	end

	# A alguno de los participantes se le aplica el Artículo 4 parrafo 1
	def art4_1?
		self.krn_denunciantes.art4_1? or self.krn_denunciados.art4_1?
	end

	def dt_obligatoria?
		self.extrn_prsncl? ? self.art4_1? : (self.riohs_off? or self.art4_1?)
	end

	def drvcns?
		self.krn_derivaciones.any?
	end

	# ------------------------------------------------------------------------ INVSTGCN

	def any_dclrcn?
		self.krn_denunciantes.map {|dte| dte.dclrcn?}.include?(true) or self.krn_denunciados.map {|dte| dte.dclrcn?}.include?(true)
	end

	def dclrcn?
		self.invstgcn_emprs? and self.any_dclrcn? and ( not self.krn_denunciantes.map {|dte| dte.dclrcn?}.include?(false) ) and ( not self.krn_denunciados.map {|dte| dte.dclrcn?}.include?(false) )
	end

	# ------------------------------------------------------------------------ CIERRE

end