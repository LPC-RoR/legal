module DnncProc
 	extend ActiveSupport::Concern

 	# TAREA Ingreso de datos de dnnc y prtcpnts
 	def tsk_ingrs?
 		!prtcpnts_minimos?								# NO cumple con el ingreso mínimo
 	end

 	def tsk_rdrccn_dnnc?
 		prtcpnts_minimos? &&							# Cumple con el ingreso mínimo
 		krn_derivaciones.none? &&						# NO tiene derivaciones
 		((rcp_empresa? && externa?) || 	
 		(rcp_externa? && !empleados_externos?))			# Denuncia recibida por entidad sin competencia
 	end

 	# Tarea de envío de mails de coordinación
 	def tsk_mails_crdncn?
 		prtcpnts_minimos? &&							# Cumple con el ingreso mínimo
 		!tsk_rdrccn_dnnc? &&							# NO hay redirección de dnnc pendiente
 		(ubccn_dnnc != KrnDenuncia::RECEPTORES[1]) &&	# La denuncia no está en una Empresa Externa
 		(!apt_coordinada? || !vrfccn_solicitada?)		# No se ha completado el envío de correos de coordinación
 	end

 	def tsk_dnncnt_info_oblgtr? 
 		prtcpnts_minimos? &&							# Cumple con el ingreso mínimo
 		!tsk_rdrccn_dnnc? &&							# NO hay redirección de dnnc pendiente				
 		(ubccn_dnnc != KrnDenuncia::RECEPTORES[2]) && 	# La denuncia no está en la DT
 		apt_coordinada? && vrfccn_solicitada? &&		# Se ha completado ele envío de correos de coordinación
 		!dnncnts_infrmds?								# Al menos una persona denunciante NO recibió la info obligatoria
 	end

 	# Opciones de derivación del denunciante
 	def tsk_dnncnt_optn_drvcn?
 		prtcpnts_minimos? &&							# Cumple con el ingreso mínimo
 		!tsk_rdrccn_dnnc? &&							# NO hay redirección de dnnc pendiente
 		(ubccn_dnnc != KrnDenuncia::RECEPTORES[2]) && 	# La denuncia no está en la DT
 		apt_coordinada? && vrfccn_solicitada? &&		# Se ha completado ele envío de correos de coordinación
 		dnncnts_infrmds? &&								# Las personas denunciantes recibieron info obligatoria
 		!!dnncnt_investigacion_local != true			# NO se ha registrado voluntad del participante para investigación local
 	end

 	# REVISAR Condición no verifica todo lo anterior
 	def tsk_cmprbnt_rcpcn?
 		!!dnncnt_investigacion_local && 				# La persona denunciante optó por una investigación interna
 		!cmprbnts_enviados?								# No se ha subido o verificado el comprobante de recepción de denuncia
 	end

 	def tsk_vrfccn_dts_incmbnts?
 		cmprbnts_enviados? &&							# Se ha subido o verificado el comprobante de recepción de denuncia
 		!!vrfccn_dts_incmbnts != true					# NO se han verificado los datos de los incumbentes
 	end

 	# Enviar notificación de la recepción de la denuncia a todos los participantes
 	def tsk_notificar_dnnc?
 		!!vrfccn_dts_incmbnts &&						# Se verificaron los datos de los incumbentes
 		!dnnc_notificada?								# No se ha notificado la denuncia
 	end

 	# Enviar medidas de resguardo a los participantes
 	def tsk_mdds_rsgrd?
 		dnnc_notificada? &&								# Se ha notificado la denuncia
 		!dnnc_mdds_rsgrd?								# NO se han notificado las medidas de resguardo
 	end

 	# Subir evidencia de la entrega de la apt a las personas denunciantes
 	def tsk_evidencia_apt?
 		dnnc_mdds_rsgrd? &&								# Se han notificado las medidas de resguardo
 		!apts?											# NO se han subido evidencias de atención psicológica temprana
 	end

 	# Opcion de derivación de la empresa
 	def tsk_emprs_optn_drvcn?
 		dnnc_notificada? &&								# Se ha notificado la denuncia
 		dnnc_mdds_rsgrd? &&								# Se han notificado las medidas de resguardo
 		apts? &&										# Se han subido evidencias de atención psicológica temprana
 		!investigacion_local && !investigacion_externa	# La empresa no ha definido investigación local/externa
 	end

 	# Cierre de la recepción de la denuncia
 	def tsk_cierre_rcpcn?
 		(!!investigacion_local || !!investigacion_externa || ubccn_dnnc == RECEPTORES[2]) &&
 		!cierre_rcpcn?									# No se ha cerrado la recepción de la denuncia
 	end

 	# Asignar investigador
 	def tsk_asigna_invstgdr?
 		ubccn_dnnc != KrnDenuncia::RECEPTORES[2] &&		# NO se encuentra en la DT
 		cierre_rcpcn? &&								# Se ha cerrado la recepción de la denuncia
 		!invstgdr_ok?									# NO tiene investigador (no objetado) || NO está notificado
 	end

 	# Análisis de la denuncia
 	def tsk_analisis_dnnc?
 		invstgdr_ok? &&									# Tiene investigador (no objetado) && está notificado
 		!analisis_ok?									# Análisis pendiente
 	end

 	# Agendamiento y toma de las declaraciones
 	def tsk_dclrcns?
 		invstgdr_ok? &&									# Tiene investigador (no objetado)
 		analisis_ok? &&									# Análisis OK
 		!tienen_dclrcn?									# NO se han subido los archivos de declaración firmados
 	end

 	# Redacción del Informe de investigación (subir)
 	def tsk_redaccion_infrm?
 		invstgdr_ok? &&									# Tiene investigador (no objetado)
 		tienen_dclrcn? && 								# Se subieron todas las declaraciones
 		!tiene_infrm?									# NO se ha subido el informe de investigación
 	end

 	# Cierre de la investigación
 	def tsk_cierre_invstgcn?
 		tiene_infrm?									# Tiene informe de investigación
 		!fecha_trmn?									# NO se ha ingresado fecha de término del a investigación
 	end

 	# Envio o recepción del informe de investigación
 	def tsk_infrm?
 		!env_rcpcn_infrm?								# NO se ha registrado el envio/recepción del informe de investigación
 	end

 	# Pronunciamiento de la Dirección del Trabajo
 	def tsk_prnncmnt?
 		ubccn_dnnc != KrnDenuncia::RECEPTORES[2] &&		# NO fue investigada por la DT
 		fecha_env_infrm? &&
 		!fecha_prnncmnt? && !prnncmnt_vncd
 	end

 	# Aplicación de las medidas de resguardo y sanciones
 	def tsk_mdds_sncns?
 		(fecha_rcpcn_infrm? ||
 		fecha_prnncmnt? || prnncmnt_vncd) &&
 		!fecha_cierre?
 	end

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

 	def mdds_rsgrd_for_attchmnt?
 		lst = fl_last_tkn('mdds_rsgrd', :fecha)
 		lst.present? and lst.archivo.present?
 	end

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