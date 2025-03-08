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

	# fecha en la que se notificó a los participantes
	def proc_fecha_ntfccn?
		self.investigacion_local
	end

	# fecha de envío de investigación a la DT 
	# fecha de recepción de certificado de recepción de denuncia
	def proc_fecha_trmtcn?
		true
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