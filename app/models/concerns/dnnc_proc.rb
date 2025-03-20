module DnncProc
 	extend ActiveSupport::Concern
 	# ================================= PROC Etapas y Tareas

 	def fechas_invstgcn?
 		# Se informó inicio de investigación
 		# La DT recibió nuestra derivación
 		# La DT notificó inicio de la investigación
 		self.fecha_trmtcn? or self.fecha_hora_dt? or self.fecha_ntfccn?
 	end

 	def evld?
 		neg = (self.evlcn_incmplt? or self.evlcn_incnsstnt?) and self.fecha_hora_corregida?
 		neg or self. evlcn_ok?
 	end

 	# ================================= 010_ingrs: Ingreso de la denuncia
 	# --------------------------------- Despliegue de formularios

 	def frms_ingrs?
 		ext = self.rcp_externa? and self.krn_empresa_externa_id.blank?
 		tip = self.via_declaracion == KrnDenuncia::VIAS_DENUNCIA[0] and self.tipo_declaracion.blank?
 		rep = self.presentado_por == KrnDenuncia::TIPOS_DENUNCIANTE[1] and self.representante.blank?
 	end

	def proc_externa?
		self.rcp_externa? and self.p_plus?
	end

	def proc_tipo?
		self.via_declaracion == KrnDenuncia::VIAS_DENUNCIA[0]
	end

	def proc_representante?
		self.presentado_por == KrnDenuncia::TIPOS_DENUNCIANTE[1]
	end

 	# --------------------------------- Control
	# ingreso de campos básicos ok?
	def tar_ingrs_ok?	# Ocupado sólo una vez
		extrn = self.rcp_externa? ? self.krn_empresa_externa_id.present? : true
		rprsntnt = self.presentado_por == 'Representante' ? self.representante.present? : true
		tp = self.via_declaracion == 'Presencial' ? self.tipo_declaracion.present? : true
		extrn and rprsntnt and tp
	end

	# El motivo de la denuncia es Violencia...
	def motivo_vlnc?	# Ocupado sólo una vez
		self.motivo_denuncia == KrnDenuncia::MOTIVOS[2]
	end

 	# ================================= 030_drvcns: Ingreso de la denuncia
 	# --------------------------------- Despliegue de derivaciones

 	def frms_drvcns?
 		loc = self.on_empresa? and ( not self.externa? ) and self.investigacion_local.blank?
 		ext = self.externa? and ( not self.on_dt? ) and ( not self.artcl41? ) and self.investigacion_externa.blank?
 		fdt = self.krn_derivaciones.on_dt? and self.rgstrs_ok? and self.fecha_hora_dt.blank?
 		loc or ext or fdt
 	end

 	def drvcn?(code)
 		self.krn_derivaciones.find_by(codigo: code)
 	end

 	# --------------------------------- Despliegue de formularios

	def artcl41?
		self.krn_denunciantes.artcl41.any? or self.krn_denunciados.artcl41.any?
	end

	def proc_solicitud_denuncia?
		self.on_dt? and self.rcp_empresa? and ( not self.externa? )
	end

	def proc_investigacion_local?
		self.on_empresa? and ( not self.externa? )
	end

	def proc_investigacion_externa?
		self.externa? and ( not self.on_dt? ) and ( not self.artcl41? )
	end

	def proc_fecha_hora_dt?
		self.krn_derivaciones.on_dt? and self.rgstrs_ok?
	end

 	# ================================= 050_crr: Cierre de la gestión inicial

 	def frms_crr?
 		ntf = self.rcp_dt? and self.fecha_ntfccn.blank?
 		trm = (self.dnnc.investigacion_local or self.investigacion_externa) and self.fecha_trmtcn.blank?
 		ntf or trm
 	end

	# fecha de la notificación enviada por la DT (anunciando la recepción de una denuncia)
	def proc_fecha_ntfccn?
		self.rcp_dt?
	end

	# fecha de envío de investigación a la DT 
	def proc_fecha_trmtcn?
		self.dnnc.investigacion_local or self.investigacion_externa
	end

 	# ================================= 060_invstgdr: Asignar Investigador

 	def objcn_invstgdr?
 		self.krn_inv_denuncias.any? ? self.krn_inv_denuncias.first.objetado : false
 	end

 	def frms_invstgdr?
 		false
 	end

	def proc_objcn_invstgdr?
		self.krn_investigadores.count == 1
	end

 	# ================================= 070_evlcn: Evaluar denuncia

 	def frms_evlcn?
 		icm = self.investigadores? and ( not self.evlcn_ok ) and self.evlcn_incmplt.blank?
 		ics = self.investigadores? and ( not self.evlcn_ok ) and self.evlcn_incnsstnt.blank?
 		eok = self.investigadores? and self.evlcn_incmplt.blank? and self.evlcn_incnsstnt.blank? and self.evlcn_ok.blank?
 		fhc = (self.evlcn_incmplt? or self.evlcn_incnsstnt?) and self.fecha_hora_corregida.blank?
 		icm or ics or eok or fhc
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

 	# ================================= 080_trmn_invstgcn: Término de la investigación

 	def frms_trmn_invstgcn?
 		self.rlzds? and self.fecha_trmn.blank?
 	end

	def proc_fecha_trmn?
		self.rlzds?
	end

 	# ================================= 100_env_rcpcn: Envío / Recepción del informe de investigación

 	def frms_env_rcpcn? 
 		(self.fecha_trmn? and self.fecha_env_infrm.blank?) or (self.fecha_hora_dt? and self.fecha_rcpcn_infrm.blank?)
 	end

	def proc_fecha_env_infrm?
		self.fecha_trmn?
	end

	def proc_fecha_rcpcn_infrm?
		self.fecha_hora_dt?
	end

 	# ================================= 110_prnncmnt: Pronunciamiento de la DT

 	def frms_prnncmnt?
 		fpr = self.fecha_env_infrm? and ( not self.prnncmnt_vncd? ) and  (not self.on_dt?) and self.fecha_prnncmnt.blank?
 		prv = self.fecha_env_infrm? and ( not self.fecha_prnncmnt? ) and self.prnncmnt_vncd.blank?
 	end

	def proc_fecha_prnncmnt?
		self.fecha_env_infrm? and ( not self.prnncmnt_vncd? ) and  (not self.on_dt?)
	end

	def proc_prnncmnt_vncd?
		self.fecha_env_infrm? and ( not self.fecha_prnncmnt? )
	end

 	# ================================= 120_mdds_sncns: Pronunciamiento de la DT

 	def frms_mdds_sncns?
 		( self.fecha_prnncmnt? or self.prnncmnt_vncd? or self.fecha_rcpcn_infrm? ) and self.crr_dnnc.blank?
 	end

 	def proc_crr_dnnc?
 		( self.fecha_prnncmnt? or self.prnncmnt_vncd? or self.fecha_rcpcn_infrm? )
 	end
end