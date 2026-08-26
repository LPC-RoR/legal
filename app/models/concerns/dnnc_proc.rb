module DnncProc
 	extend ActiveSupport::Concern

 	# TAREAS -------------------------------------- etp_rcpcn
 	def tsk_ingrs?
 		!prtcpnts_minimos?								# NO cumple con el ingreso mínimo
 	end

 	# TAREA Ingreso de datos de dnnc y prtcpnts
 	def tsk_dcmnts_cntrlds?
 		prtcpnts_minimos? && 							# NO cumple con el ingreso mínimo
 		!dcmnts_cntrlds_rcpcn?							# No se han generado los documentos obligatorios de recepción
 	end

 	# Cierre de la recepción de la denuncia
 	def tsk_cierre_rcpcn?
 		dcmnts_cntrlds_rcpcn? &&						# Se han ingresado los documentos obligatorios de recepción
 		(!flds_cierre? || !trmts_cierre?)
 	end

 	# TAREAS -------------------------------------- etp_invstgcn
 	# Asignar investigador
 	def tsk_frm_invstgcn?
 		flds_cierre? && trmts_cierre? &&				# Se ha realizado los trámites de cierre
 		!on_dt? &&										# Nose recibió ni se derivó a la DT
 		(!tiene_invstgdr_valido? ||						# NO tiene investigador (no objetado) || Con objeción rechazada
 			!resuelta_o_corregida?)
 	end

 	def tsk_dcmnts_cntrlds_invstgcn?
 		flds_cierre? && trmts_cierre? &&				# Se ha realizado los trámites de cierre
 		!on_dt? &&										# Nose recibió ni se derivó a la DT
 		tiene_invstgdr_valido? &&						# NO tiene investigador (no objetado) || Con objeción rechazada
 		resuelta_o_corregida? &&						# Denuncia resuelta o corregida (Evaluación)
 		!dcmnts_cntrlds_invstgcn?						# No se han generado los documentos obligatorios de investigación
 	end

 	# Agendamiento y toma de las declaraciones
 	def tsk_dclrcns?
 		flds_cierre? && trmts_cierre? &&				# Se ha realizado los trámites de cierre
 		!on_dt? &&										# Nose recibió ni se derivó a la DT
 		tiene_invstgdr_valido? &&						# NO tiene investigador (no objetado) || Con objeción rechazada
 		resuelta_o_corregida? &&						# Denuncia resuelta o corregida (Evaluación)
 		dcmnts_cntrlds_invstgcn? &&						# Documentos obligatorios de investigación OK
 		!dclrcns_completas?								# NO se han subido los archivos de declaración firmados || No son excepciones
 	end

 	# Redacción del Informe de investigación (subir)
 	def tsk_redaccion_infrm?
 		!on_dt? &&										# Nose recibió ni se derivó a la DT
 		dclrcns_completas? && 							# Se subieron todas las declaraciones
 		!tiene_infrm?									# NO se ha subido el informe de investigación
 	end

 	# Cierre de la investigación
 	def tsk_cierre_invstgcn?
 		tiene_infrm? &&									# Tiene informe de investigación
 		!fecha_termino_investigacion.present?			# NO se ha ingresado fecha de término del a investigación
 	end

 	# TAREAS -------------------------------------- etp_infrm
 	# Envio o recepción del informe de investigación
 	def tsk_infrm?
 		fecha_termino_investigacion.present? &&			# NO se ha registrado el envio/recepción del informe de investigación
 		!krn_tramites.deposito_investigacion.present?	# NO se ha realizado el depósito del informe de investigación.
 	end

 	# TAREAS -------------------------------------- etp_prnncmnt
 	# Pronunciamiento de la Dirección del Trabajo
 	def tsk_prnncmnt?
 		krn_tramites.deposito_investigacion.present? &&
 		!fecha_recepcion_pronunciamiento.present? && !prnncmnt_vncd
 	end

 	# TAREAS -------------------------------------- etp_mdds_sncns
 	# REVISAR fecha_rcpcn_infrm?
 	# Aplicación de las medidas de resguardo y sanciones
 	def tsk_mdds_sncns?
 		(fecha_rcpcn_infrm? ||
 		fecha_recepcion_pronunciamiento.present? || prnncmnt_vncd) &&
 		!fecha_cierre?
 	end

 	# TAREAS -------------------------------------- etp_terminada (?)
 	# Procedimiento terminado
 	def tsk_prcdmnt_trmnd?
 		fecha_cierre?
 	end
 	
 	# ================================= PROC Etapas

 	# Los datos de los participantes ingresados hasta el momento están completos
	def rgstrs_ok?
		self.krn_denunciantes.rgstrs_ok? and (self.krn_denunciados.rgstrs_ok? or self.violencia?)
	end

 	# Reconocer declaración Verbal: recibida en la empresa, entregada presencial en forma verbal
 	def verbal?
 		self.rcp_empresa? and self.via_declaracion == 'Presencial' and self.tipo_declaracion == 'Verbal'
 	end

 	def fechas_crr_rcpcn?
 		self.fecha_trmtcn? or self.fecha_ntfccn? or (self.solicitud_denuncia ? self.fecha_dvlcn? : self.fecha_hora_dt?)
 	end


 	# ---------------------------------------------------- ARCHIVOS CONTROLADOS RECEPCION

 	# ---------------------------------------------------- 
 	# Sirve para controlar crud de los investigadores
 	def objcn_invstgdr?
 		self.krn_inv_denuncias.any? ? self.krn_inv_denuncias.first.objetado : false
 	end

	def antecedentes_objecion?
		self.act_archivos.exists?(act_archivo: 'objecion_antcdnts')
	end

	def declaraciones_completas?
		todos_los_sujetos = krn_denunciantes + krn_denunciados + krn_denunciantes.flat_map(&:krn_testigos) + krn_denunciados.flat_map(&:krn_testigos)
		todos_los_sujetos.all? do |sujeto|
			sujeto.act_archivos.exists?(act_archivo: 'declaracion')
		end
	end

 	### ==================================================================================

	# saque la fecha de devolución porque se procesará desde la devolución.
 	# Chequeo de devolución de denuncia solicitada FALTA RECHAZO DE LA SOLICITUD
 	def chck_dvlcn?
 		self.solicitud_denuncia ? self.on_empresa? : true
 	end


 	# --------------------------------- Despliegue de formularios

 	# Se usa para evitar crear una "derivación" que ya se haya creado en la denuncia
 	def drvcn?(code)
 		self.krn_derivaciones.find_by(codigo: code)
 	end

end