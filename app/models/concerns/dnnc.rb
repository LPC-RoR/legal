module Dnnc
 	extend ActiveSupport::Concern

	def css_id
		'dnnc'
	end

	def rgstrs_ok?
		self.krn_denunciantes.rgstrs_ok? and self.krn_denunciados.rgstrs_ok?
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

	def proc_prnncmnt_vncd?
		self.fecha_env_infrm? and ( not self.fecha_prnncmnt? )
#		self.fecha_env_infrm? and ( not self.fecha_prnncmnt? ) and  (not self.on_dt?)
	end

	def proc_fecha_prnncmnt?
		self.fecha_env_infrm? and ( not self.prnncmnt_vncd? ) and  (not self.on_dt?)
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