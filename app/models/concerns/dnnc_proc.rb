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

	# fecha de la notificación enviada por la DT (anunciando la recepción de una denuncia)
	def proc_fecha_ntfccn?
		self.rcp_dt?
	end

	# fecha de envío de investigación a la DT 
	def proc_fecha_trmtcn?
		self.dnnc.investigacion_local or self.investigacion_externa
	end

 	# ================================= 060_invstgdr: Asignar Investigador

	def proc_objcn_invstgdr?
		self.krn_investigadores.count == 1
	end

 	# ================================= 070_evlcn: Evaluar denuncia

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

	def proc_fecha_trmn?
		self.rlzds?
	end

 	# ================================= 100_env_rcpcn: Envío / Recepción del informe de investigación

	def proc_fecha_env_infrm?
		self.fecha_trmn?
	end

	def proc_fecha_rcpcn_infrm?
		self.fecha_hora_dt?
	end

 	# ================================= 110_prnncmnt: Pronunciamiento de la DT

	def proc_fecha_prnncmnt?
		self.fecha_env_infrm? and ( not self.prnncmnt_vncd? ) and  (not self.on_dt?)
	end

	def proc_prnncmnt_vncd?
		self.fecha_env_infrm? and ( not self.fecha_prnncmnt? )
	end

end