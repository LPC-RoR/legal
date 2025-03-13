module Dnnc
 	extend ActiveSupport::Concern

	def css_id
		'dnnc'
	end

	# ------------------------------------------------------------------------ PROC CNDTNS

	def proc_externa?
		self.rcp_externa? and self.p_plus?
	end

	def proc_tipo?
		self.via_declaracion == KrnDenuncia::VIAS_DENUNCIA[0]
	end

	def proc_representante?
		self.presentado_por == KrnDenuncia::TIPOS_DENUNCIANTE[1]
	end

	def proc_solicitud_denuncia?
		self.on_dt? and self.rcp_empresa? and ( not self.externa? )
	end

	def proc_investigacion_local?
		self.on_empresa? and ( not self.externa? )
	end

	def proc_fecha_hora_dt?
		self.on_dt?
	end

	# fecha en la que se notificó a los participantes
	def proc_fecha_ntfccn?
		self.fl?('mdds_rsgrd')
	end

	# fecha de envío de investigación a la DT 
	# fecha de recepción de certificado de recepción de denuncia
	def proc_fecha_trmtcn?
		self.fl?('mdds_rsgrd') and ( not self.fecha_hora_dt? )
	end

	def proc_objcn_invstgdr?
		self.krn_investigadores.count == 1
	end

	def proc_evlcn_incmplt?
		self.krn_investigadores.any? and ( not self.evlcn_ok )
	end

	def proc_evlcn_incnsstnt?
		self.krn_investigadores.any? and ( not self.evlcn_ok )
	end

	def proc_evlcn_ok?
		self.krn_investigadores.any? and self.evlcn_incmplt.blank? and self.evlcn_incnsstnt.blank?
	end

	def proc_fecha_hora_corregida?
		self.evlcn_incmplt? or self.evlcn_incnsstnt?
	end

	def proc_fecha_trmn?
		self.rlzds?
	end

	def proc_fecha_env_infrm?
		self.fecha_trmn? or self.fecha_hora_dt?
	end

	def proc_plz_prnncmnt_vncd?
		self.fecha_env_infrm? and ( not self.fecha_prnncmnt? ) and  (not self.on_dt?)
	end

	def proc_fecha_prnncmnt?
		self.fecha_env_infrm? and ( not self.plz_prnncmnt_vncd? ) and  (not self.on_dt?)
	end

	# ------------------------------------------------------------------------ FL CNDTNS


	def fl_dnnc_denuncia?
		self.tipo_declaracion != 'Verbal'
	end

	def fl_dnnc_acta?
		self.tipo_declaracion == 'Verbal'
	end

	def fl_dnnc_notificacion?
		self.rcp_dt?
	end

	def fl_dnnc_certificado?
		self.rcp_dt?
	end

	def fl_dnncnt_rprsntcn?
		self.proc_representante?
	end

	def fl_mdds_rsgrd?
		true
	end

	def fl_antcdnts_objcn?
		self.objcn_invstgdr
	end

	def fl_rslcn_objcn?
		self.evlcn_incmplt? or self.evlcn_incnsstnt?
	end

	# Evaluación de la denuncia
	def fl_dnnc_evlcn?
		self.on_empresa?
	end

	def fl_dnnc_corrgd?
		self.evlcn_incmplt? or self.evlcn_incnsstnt?
	end

	def fl_infrm_invstgcn?
		self.rlzds?
	end

	def fl_mdds_crrctvs?
		self.rlzds?
	end

	def fl_sncns?
		self.rlzds?
	end

	def fl_prnncmnt_dt?
		self.fecha_prnncmnt?
	end

	def fl_dnnc_mdds_sncns?
		self.fecha_env_infrm? or self.plz_prnncmnt_vncd?
	end

	# Sólo para desplegar TODA la lista en dnnc
	def fl_dnncnt_diat_diep?
		false
	end

	def fl_prtcpnts_dclrcn?
		false
	end

	def fl_prtcpnts_antcdnts?
		false
	end

	# ------------------------------------------------------------------------ PRTCPNTS

	def drvcn_dnncnt?
		self.krn_derivaciones.find_by(codigo: 'drvcn_dnncnt')
	end

	def drvcn_emprs?
		self.krn_derivaciones.find_by(codigo: 'drvcn_emprs')
	end

	# ------------------------------------------------------------------------ PRTCPNTS

	def artcl41?
		self.krn_denunciantes.artcl41.any? or self.krn_denunciados.artcl41.any?
	end

	# Registros revisados
	def rgstrs_rvsds?
		self.krn_denunciantes.rvsds? and self.krn_denunciados.rvsds?
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