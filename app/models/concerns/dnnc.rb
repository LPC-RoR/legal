module Dnnc
 	extend ActiveSupport::Concern

	PRESENTADORES = ['Denunciante', 'Representante']

	def css_id
		'dnnc'
	end

	# ------------------------------------------------------------------------ INGRS

	def p_externa?
		self.receptor_denuncia == 'Empresa externa' and self.krn_empresa_externa_id.blank? and self.p_plus?
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

	def fl_dnnc_certificado?
		self.receptor_denuncia == 'Dirección del Trabajo'
	end

	def fl_dnncnt_rprsntcn?
		self.p_representante?
	end

	def rgstrs_rvsds?
		self.krn_denunciantes.rvsds? and self.krn_denunciados.rvsds?
	end

	# ------------------------------------------------------------------------ DRVCNS

	def p_solicitud_denuncia?
		self.solicitud_denuncia != true and (self.receptor_denuncia == 'Dirección del Trabajo' or ( self.krn_derivaciones.empty? ? false : (self.krn_derivaciones.lst.dstn_dt? and ( not self.externa? ) ) ))
	end

	def p_investigacion_local?
		self.investigacion_local.blank? and self.on_empresa? and ( not self.externa? )
	end

	def art4_1?
		self.krn_denunciantes.art4_1? or self.krn_denunciados.art4_1?
	end

	def rcpcn_extrn?
		self.krn_derivaciones.rcpcn_extrn?
	end

	def rcpcn_dt?
		self.krn_derivaciones.rcpcn_dt?
	end

	def drvcn_art4_1?
		self.krn_derivaciones.drvcn_art4_1?
	end

	def drvcn_dnncnt?
		self.krn_derivaciones.drvcn_dnncnt?
	end

	def drvcn_emprs?
		self.krn_derivaciones.drvcn_emprs?
	end

	def drvcn_ext?
		self.krn_derivaciones.drvcn_ext?
	end

	def drvcn_ext_dt?
		self.krn_derivaciones.drvcn_ext_dt?
	end

	def responsable
		self.krn_derivaciones.empty? ? self.receptor_denuncia : self.krn_derivaciones.last.destino
	end

	# ------------------------------------------------------------------------ DRVCNS

	def fl_mdds_rsgrd?
		true
	end

	def fmdds_rsgrd?
		self.fl?('mdds_rsgrd')
	end

	# ------------------------------------------------------------------------ PRTCPNTS


	def prtcpnts?
		self.mtv_vlnc? ? self.dnncnts_any? : (self.dnncnts_any? and self.dnncds_any?)
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