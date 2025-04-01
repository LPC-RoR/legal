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
	# saque la fecha de devolución porque se procesará desde la devolución.
 	def fechas_invstgcn?
 		self.fecha_trmtcn? or self.fecha_ntfccn? or (self.solicitud_denuncia ? self.fecha_dvlcn? : self.fecha_hora_dt?)
 	end

 	# Chequeo de devolución de denuncia solicitada FALTA RECHAZO DE LA SOLICITUD
 	def chck_dvlcn?
 		self.solicitud_denuncia ? self.on_empresa? : true
 	end

 	# ================================= 030_drvcns: Ingreso de la denuncia

	def artcl41?
		self.krn_denunciantes.artcl41.any? or self.krn_denunciados.artcl41.any?
	end

	def fecha_drvcn_dt
		self.krn_derivaciones.dts.empty? ? nil : self.krn_derivaciones.dts.first.fecha
	end

	def fecha_plz_rcpcn
		self.fecha_drvcn_dt.blank? ? (self.fecha_trmtcn || self.fecha_ntfccn) : self.fecha_drvcn_dt
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
 	# ================================= 050_crr: Cierre de la gestión inicial

	# fecha de la notificación enviada por la DT (anunciando la recepción de una denuncia)
	# NO se puede pedir devolución de estas denuncias
	def proc_fecha_ntfccn?
		self.rcp_dt?
	end

	# Fecha en la que se informo el inicio de una investigación a la DT
 	def proc_fecha_trmtcn?
 		(self.dnnc.investigacion_local or self.investigacion_externa)
 	end

 	# Fecha del certificado en el que la DT acusa recibo de la derivación
 	def proc_fecha_hora_dt?
 		self.krn_derivaciones.on_dt?
 	end

 	def frms_crr?
 		self.proc_fecha_ntfccn? or self.proc_fecha_trmtcn? or self.proc_fecha_hora_dt? or self.proc_fecha_dvlcn?
 	end

	def proc_fecha_dvlcn?
		self.solicitud_denuncia and self.on_empresa?
	end
 	# ================================= 060_invstgdr: Asignar Investigador

 	def proc_objcn_acogida?
 		self.objcn_invstgdr? and (not self.objcn_rechazada)
 	end

 	def proc_objcn_rechazada?
 		self.objcn_invstgdr? and (not self.objcn_acogida)
 	end

 	def frms_invstgdr?
 		self.proc_objcn_acogida? or self.proc_objcn_rechazada?
 	end

 	# Sirve para controlar crud de los investigadores
 	def objcn_invstgdr?
 		self.krn_inv_denuncias.any? ? self.krn_inv_denuncias.first.objetado : false
 	end

 	def objcn_ok?
 		self.objcn_invstgdr? ? (self.objcn_rechazada? or (self.objcn_acogida? and self.krn_inv_denuncias.count == 2)) : true
 	end

 	# ================================= 070_evlcn: Evaluar denuncia

 	def evld?
 		(self.evlcn_desaprobada? and self.fecha_hora_corregida?) or self. evlcn_ok?
 	end

	def proc_evlcn_incmplt?
		self.krn_investigadores.any? and ( not self.evlcn_incnsstnt )
	end

	def proc_evlcn_incnsstnt?
		self.krn_investigadores.any? and ( not self.evlcn_incmplt )
	end

	def proc_evlcn_ok?
		self.krn_investigadores.any? and (not self.evlcn_desaprobada?)
	end

	def proc_evlcn_desaprobada?
		self.krn_investigadores.any? and (not self.evlcn_ok?)
	end

	def proc_fecha_hora_corregida?
		self.proc_evlcn_desaprobada?
	end

 	def frms_evlcn?
 		self.proc_evlcn_ok? or self.proc_fecha_hora_corregida? or self.proc_fecha_hora_corregida?
 	end

 	# ================================= 080_trmn_invstgcn: Término de la investigación

 	def frms_trmn_invstgcn?
 		self.proc_fecha_trmn?
 	end

	def proc_fecha_trmn?
		self.rlzds?
	end

 	# ================================= 100_env_rcpcn: Envío / Recepción del informe de investigación

 	def frms_env_rcpcn? 
 		self.fecha_trmn? or self.fecha_hora_dt?
 	end

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

 	def frms_prnncmnt?
 		self.proc_fecha_prnncmnt? or self.proc_prnncmnt_vncd?
 	end

 	# ================================= 120_mdds_sncns: Pronunciamiento de la DT

 	def frms_mdds_sncns?
 		self.proc_crr_dnnc?
 	end

 	def proc_crr_dnnc?
 		( self.fecha_prnncmnt? or self.prnncmnt_vncd? or self.fecha_rcpcn_infrm? )
 	end
end