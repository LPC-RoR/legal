module Dnnc
 	extend ActiveSupport::Concern

	PRESENTADORES = ['Denunciante', 'Representante']

	def css_id
		'dnnc'
	end

	# ------------------------------------------------------------------------ INGRS

	def p_externa?
		self.krn_empresa_externa_id.blank? and self.p_plus?
	end

	def p_tipo?
		self.tipo_declaracion.blank? and self.via_declaracion == KrnDenuncia::VIAS_DENUNCIA[0]
	end

	def p_representante?
		self.representante.blank? and self.presentado_por == KrnDenuncia::TIPOS_DENUNCIANTE[1]
	end

	def fl_dnnc_denuncia?
		self.tipo_declaracion != 'Verbal'
	end

	def fl_dnnc_acta?
		self.tipo_declaracion == 'Verbal'
	end

	def fl_dnnc_notificacion?
		self.receptor_denuncia == 'Dirección del Trabajo'
	end

	def fl_dnncnt_rprsntcn?
		self.p_representante?
	end


	def rgstrs_ok?
		self.krn_denunciantes.rgstrs_ok? and self.krn_denunciados.rgstrs_ok?
	end

	# ------------------------------------------------------------------------ PRTCPNTS


	def prtcpnts?
		self.no_vlnc? ? (self.dnncnts_any? and self.dnncds_any?) : self.dnncnts_any?
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