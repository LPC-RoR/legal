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

 	# --------------------------------- Despliegue de formularios

 	# Se usa para evitar crear una "derivación" que ya se haya creado en la denuncia
 	def drvcn?(code)
 		self.krn_derivaciones.find_by(codigo: code)
 	end

 	# --------------------------------- Despliegue de formularios
 	# ================================= 050_crr: Cierre de la gestión inicial
 	# ================================= 060_invstgdr: Asignar Investigador

 	# Sirve para controlar crud de los investigadores
 	def objcn_invstgdr?
 		self.krn_inv_denuncias.any? ? self.krn_inv_denuncias.first.objetado : false
 	end

 	def objcn_ok?
 		self.objcn_invstgdr? ? (self.objcn_rechazada or (self.objcn_acogida and self.krn_inv_denuncias.count == 2)) : true
 	end

 	# ================================= 070_evlcn: Evaluar denuncia

 	def evld?
 		((self.evlcn_incmplt or self.evlcn_incnsstnt) and self.fecha_hora_corregida?) or self. evlcn_ok?
 	end

 	# ================================= 080_trmn_invstgcn: Término de la investigación
 	# ================================= 100_env_rcpcn: Envío / Recepción del informe de investigación
 	# ================================= 110_prnncmnt: Pronunciamiento de la DT
 	# ================================= 120_mdds_sncns: Pronunciamiento de la DT

end