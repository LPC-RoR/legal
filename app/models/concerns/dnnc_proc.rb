module DnncProc
 	extend ActiveSupport::Concern
 	# ================================= PROC Etapas y Tareas

	# El motivo de la denuncia es Violencia... Usado para saber si se ingresan personas denunciadas
	def motivo_vlnc?	# Ocupado sólo una vez
		self.motivo_denuncia == KrnDenuncia::MOTIVOS[2]
	end

 	# Los datos de los participantes ingresados hasta el momento están completos
	def rgstrs_ok?
		self.krn_denunciantes.rgstrs_ok? and self.krn_denunciados.rgstrs_ok?
	end

	# fecha_trmtcn? 	: Fecha en la que se informa inicio de una investigación a la DT
	# fecha_hora_dt?	: Fecha del certificado emitido por la DT en el que acusa recepción de la denuncia que les derivamos
	# fecha_ntfccn?		: Fecha en la que la DT notificó inicio de la investigación de una denuncia recibido por ellos
	# fecha_dvlcn?		: Fecha en la que ocurre la devolución de la denuncia (solicitada) desde la DT
 	def fechas_invstgcn?
 		self.fecha_trmtcn? or self.fecha_hora_dt? or self.fecha_ntfccn? or self.fecha_dvlcn?
 	end

 	# Chequeo de devolución de denuncia solicitada FALTA RECHAZO DE LA SOLICITUD
 	def chck_dvlcn?
 		self.solicitud_denuncia ? self.on_empresa? : true
 	end

 	# ================================= 030_drvcns: Ingreso de la denuncia

	def artcl41?
		self.krn_denunciantes.artcl41.any? or self.krn_denunciados.artcl41.any?
	end

 	# --------------------------------- Despliegue de formularios

	def proc_investigacion_local?
		self.on_empresa? and self.empresa?
	end

	def proc_investigacion_externa?
		self.on_externa? and self.externa? and ( not self.artcl41? )
	end

 	def frms_drvcns?
 		self.proc_investigacion_local? or self.proc_investigacion_externa?
 	end

 	# Se usa para evitar crear una "derivación" que ya se haya creado en la denuncia
 	def drvcn?(code)
 		self.krn_derivaciones.find_by(codigo: code)
 	end

 	# --------------------------------- Despliegue de formularios
 	# DEPRECATED
	def proc_solicitud_denuncia?
		self.on_dt? and self.rcp_empresa? and ( not self.externa? )
	end

	# DEPRECATED
	def proc_fecha_hora_dt?
		self.krn_derivaciones.on_dt? and self.rgstrs_ok? and self.chck_dvlcn?
	end

 	# ================================= 050_crr: Cierre de la gestión inicial

 	def frm_fecha_hora_dt?
 		self.krn_derivaciones.on_dt? and self.rgstrs_ok? and self.fecha_hora_dt.blank?
 	end

 	def frm_fecha_ntfccn?
 		self.rcp_dt? and self.fecha_ntfccn.blank?
 	end

 	def frm_fecha_trmtcn?
 		(self.dnnc.investigacion_local or self.investigacion_externa) and self.fecha_trmtcn.blank?
 	end

 	def frms_crr?
 		self.frm_fecha_ntfccn? or self.frm_fecha_trmtcn?
 	end

	# fecha de la notificación enviada por la DT (anunciando la recepción de una denuncia)
	def proc_fecha_ntfccn?
		self.rcp_dt? and (not self.solicitud_denuncia)
	end

	# fecha de envío de investigación a la DT 
	def proc_fecha_trmtcn?
		(self.investigacion_local or self.investigacion_externa) and (not self.solicitud_denuncia)
	end

	def proc_fecha_dvlcn?
		self.solicitud_denuncia
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

 	def evld?
 		neg = (self.evlcn_incmplt? or self.evlcn_incnsstnt?) and self.fecha_hora_corregida?
 		neg or self. evlcn_ok?
 	end

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

 	def frm_fecha_prnncmnt?
 		self.fecha_env_infrm? and ( not self.prnncmnt_vncd? ) and  (not self.on_dt?) and self.fecha_prnncmnt.blank?
 	end

 	def frm_prnncmnt_vncd?
 		self.fecha_env_infrm? and ( not self.fecha_prnncmnt? ) and self.prnncmnt_vncd.blank?
 	end

 	def frms_prnncmnt?
 		self.frm_fecha_prnncmnt? or self.frm_prnncmnt_vncd?
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