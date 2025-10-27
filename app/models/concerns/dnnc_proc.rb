module DnncProc
 	extend ActiveSupport::Concern

 	# ================================= KrnPrcdmnt

 	def plz_fecha_inicio(etapa)
 		case etapa
 		when :etp_rcpcn
 			fecha_hora
 		when :etp_invstgcn
 			# 1.- En caso de 'devolución' esta fecha prima por sobre todas las anteriores
 			# 2.- Si la denuncia fue derivada a la DT, se usa la fecha del certificado
 			# 3.- Se usa la evcha de recepción
 			fecha_dvlcn? ? fecha_dvlcn : (fecha_hora_dt? ? fecha_hora_dt : fecha_hora)
 		when :etp_infrm
 			# ¿Es necesario fijar un hito 'término de la investigación' por ahora no lo tenemos
 			# Mientras asumimos que el plazo es SIEMPRE dos hábiles despues de 30
 			base = fecha_dvlcn? ? fecha_dvlcn : (fecha_hora_dt? ? fecha_hora_dt : fecha_hora)
 			::CalFeriado.plazo_habil(base, 30)
 		when :etp_prnncmnt
 			# No aplica a las investigaciones investigadas por la DT
 			# Si aplica, se calcula a partir de la fecha en la cual se envió el informe a la DT
 			unless on_dt?
 				fecha_env_infrm
 			end
 		when :etp_mdds_sncns
 			# 1.- Investigada en la DT: fecha de recepción del informe
 			# 2.- Plazo para el pronunciamiento vencido: 30 hábiles desde la fecha de envío
 			# 3.- Fecha del pronunciamiento
 			on_dt? ? fecha_rcpcn_infrm : (prnncmnt_vncd ? ::CalFeriado.plazo_habil(fecha_env_infrm, 30) : fecha_prnncmnt)
 		end
 	end

 	def plz_fecha_cmplmnt(etapa)
 		case etapa
 		when :etp_rcpcn
 			rcp_dt? ? nil : (on_dt? ? krn_derivaciones.last.fecha.to_date : fecha_trmtcn)
 		when :etp_invstgcn
 			on_dt? ? nil : dnnc.fecha_trmn
 		when :etp_infrm
 			on_dt? ? fecha_rcpcn_infrm : fecha_env_infrm
 		when :etp_prnncmnt
 			on_dt? ? nil : dnnc.fecha_prnncmnt
 		when :etp_mdds_sncns
 			fecha_cierre
 		end
 	end

 	def plazo(etapa)
 		case etapa
 		when :etp_rcpcn
 			CalFeriado.plazo_habil(plz_fecha_inicio(:etp_rcpcn), 3)
 		when :etp_invstgcn
 			CalFeriado.plazo_habil(plz_fecha_inicio(:etp_invstgcn), 30)
 		when :etp_infrm
 			CalFeriado.plazo_habil(plz_fecha_inicio(:etp_infrm), 2)
 		when :etp_prnncmnt
 			CalFeriado.plazo_habil(plz_fecha_inicio(:etp_prnncmnt), 30)
 		when :etp_mdds_sncns
 			CalFeriado.plazo_corrido(plz_fecha_inicio(:etp_mdds_sncns), 15)
 		end
 	end

 	# Ingreso de datos de dnnc y prtcpants
 	def tsk_ingrs?
 		not prtcpnts_minimos?
 	end

 	# La empresa recibe denuncia de externa
 	def tsk_emprs_drvcn_extrn?
 		on_rcp? and
 		extrn_recibida_por_emprs?
 	end

 	# Empresa externa recibe denuncia de la empresa
 	def tsk_extrn_drvcn_emprs?
 		on_rcp? and
 		emprs_recibida_por_extrn?
 	end

 	# Entrega de información obligatoria a los denunciantes
 	# 1.- No puede haber derivaciones entre empresas pendientes
 	# 2.- No puede esta en la DT
 	def tsk_dnncnt_info_oblgtr? 
 		proc_not_drvcn_entre_empresas? and
 		not_on_dt? and (not dnncnts_infrmds?)
 	end

 	# Opciones de derivación del denunciante
 	def tsk_dnncnt_optn_drvcn?
 		campos = [dnncnt_investigacion_local]
 		prtcpnts_minimos? and not_on_dt? and dnncnts_infrmds? and
 		campos.count(true) == 0
 	end

 	# Coordinación de atención psicológica temprana
 	def tsk_crdncn_apt?
 		(on_dt? or (on_empresa? and dnncnt_investigacion_local) or empresa?) and
 		(not apt_coordinada?)
 	end

 	# Las personas denunciantes tienen su comprobante, pero hay que verificar que se haya subido el comprobante firmado.
 	def tsk_comprobantes_firmados?
 		not_on_dt? and apt_coordinada? and (not comprobantes_firmados?)
 	end

 	# Enviar notificación de la recepción de la denuncia a todos los participantes
 	def tsk_notificar_dnnc?
 		(on_dt? or (not_on_dt? and apt_coordinada? and comprobantes_firmados?)) and
 		( not dnnc_notificada?)
 	end

 	# Enviar medidas de resguardo a los participantes
 	def tsk_mdds_rsgrd?
 		(on_dt? or (not_on_dt? and apt_coordinada? and comprobantes_firmados? and dnnc_notificada?)) and
 		(not mdds_rsgrd?)
 	end

 	# Subir evidencia de la entrega de la apt a las personas denunciantes
 	def tsk_evidencia_apt?
 		(on_dt? or (not_on_dt? and apt_coordinada? and comprobantes_firmados?)) and
 		(not evidencia_apt?)
 	end

 	# Opcion de derivación de la empresa
 	def tsk_emprs_optn_drvcn?
 		campos = [investigacion_local, investigacion_externa]
 		not_on_dt? and evidencia_apt? and
 		campos.count(true) == 0
 	end

 	# Cierre de la recepción de la denuncia
 	def tsk_cierre_rcpcn?
 		evidencia_apt? and 
 		(on_dt? or investigacion_local or investigacion_externa) and
 		(not fecha_hora_dt) and (not fecha_trmtcn) and (not fecha_ntfccn)
 	end

 	# Asignar investigador
 	def tsk_asigna_invstgdr?
 		campos = [fecha_hora_dt?, fecha_trmtcn?, fecha_ntfccn?]
 		not_on_dt? and
 		campos.count(true) == 1 and krn_inv_denuncias.none?
 	end

 	# Análisis de la denuncia
 	def tsk_analisis_dnnc?
 		not_on_dt? and krn_inv_denuncias.any? and
 		(not analizada?)
 	end

 	# Agendamiento y toma de las declaraciones
 	def tsk_dclrcns?
 		not_on_dt? and analizada? and
 		(not tienen_dclrcn?)
 	end

 	# Redacción del Informe de investigación (subir)
 	def tsk_redaccion_infrm?
 		not_on_dt? and tienen_dclrcn? and
 		(not tiene_infrm?)
 	end

 	# Cierre de la investigación
 	def tsk_cierre_invstgcn?
 		not_on_dt? and tiene_infrm? and
 		(not fecha_trmn?)
 	end

 	# Envio o recepción del informe de investigación
 	def tsk_infrm?
 		((not_on_dt? and fecha_trmn?) or on_dt?) and
 		(not fecha_env_infrm?) and (not fecha_rcpcn_infrm?)
 	end

 	# Pronunciamiento de la Dirección del Trabajo
 	def tsk_prnncmnt?
 		not_on_dt? and
 		fecha_env_infrm? and
 		(not fecha_prnncmnt?) and (not prnncmnt_vncd)
 	end

 	# Aplicación de las medidas de resguardo y sanciones
 	def tsk_mdds_sncns?
 		(on_dt? or (fecha_prnncmnt? or prnncmnt_vncd)) and
 		(not fecha_cierre?)
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

 	def dnncnts_info_oblgtr?
 		self.krn_denunciantes.map {|dnncnt| dnncnt.info_oblgtr?}.uniq.join('-') == 'true'
 	end

 	def fechas_crr_rcpcn?
 		self.fecha_trmtcn? or self.fecha_ntfccn? or (self.solicitud_denuncia ? self.fecha_dvlcn? : self.fecha_hora_dt?)
 	end

 	def invstgcn_sents?
 		self.krn_denunciantes.invstgcn_sents? and self.krn_denunciados.invstgcn_sents?
 	end

 	def mdds_rsgrd_sents?
 		self.krn_denunciantes.mdds_rsgrd_sents? and self.krn_denunciados.mdds_rsgrd_sents?
 	end

 	def invstgdr_sents?
 		self.krn_denunciantes.invstgdr_sents? and self.krn_denunciados.invstgdr_sents?
 	end

 	def ntfcn_drvcns_sents?
 		self.krn_derivaciones.empty? ? true : self.krn_derivaciones.map {|drvcn| drvcn.pdf_registros.any? }.join('-') == 'true'
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