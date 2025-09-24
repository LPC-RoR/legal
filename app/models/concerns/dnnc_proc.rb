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

 	def tsk_notificar_dnnc?
 		(on_dt? or (not_on_dt? and apt_coordinada? and comprobantes_firmados?)) and
 		( not dnnc_notificada?)
 	end

 	def tsk_mdds_rsgrd?
 		(on_dt? or (not_on_dt? and apt_coordinada? and comprobantes_firmados? and dnnc_notificada?)) and
 		(not mdds_rsgrd?)
 	end

 	def tsk_evidencia_apt?
 		(on_dt? or (not_on_dt? and apt_coordinada? and comprobantes_firmados?)) and
 		(not evidencia_apt?)
 	end

 	def tsk_emprs_optn_drvcn?
 		campos = [investigacion_local, investigacion_externa]
 		not_on_dt? and evidencia_apt? and
 		campos.count(true) == 0
 	end

 	def tsk_cierre_rcpcn?
 		evidencia_apt? and 
 		(on_dt? or investigacion_local or investigacion_externa) and
 		(not fecha_hora_dt) and (not fecha_trmtcn) and (not fecha_ntfccn)
 	end

 	def tsk_asigna_invstgdr?
 		campos = [fecha_hora_dt?, fecha_trmtcn?, fecha_ntfccn?]
 		not_on_dt? and
 		campos.count(true) == 1 and krn_inv_denuncias.none?
 	end

 	def tsk_analisis_dnnc?
 		not_on_dt? and krn_inv_denuncias.any? and
 		(not analizada?)
 	end

 	def tsk_dclrcns?
 		not_on_dt? and analizada? and
 		(not tienen_dclrcn?)
 	end

 	def tsk_redaccion_infrm?
 		not_on_dt? and tienen_dclrcn? and
 		(not tiene_infrm?)
 	end

 	def tsk_cierre_invstgcn?
 		not_on_dt? and tiene_infrm? and
 		(not fecha_trmn?)
 	end

 	def tsk_infrm?
 		not_on_dt? and fecha_trmn? and
 		(not fecha_env_infrm?) and (not fecha_rcpcn_infrm?)
 	end

 	def tsk_prnncmnt?
 		not_on_dt? and
 		fecha_env_infrm? and
 		(not fecha_prnncmnt?) and (not prnncmnt_vncd)
 	end

 	def tsk_mdds_sncns?
 		(on_dt? or (fecha_prnncmnt? or prnncmnt_vncd)) and
 		(not fecha_cierre?)
 	end

 	def tsk_prcdmnt_trmnd?
 		fecha_cierre?
 	end
 	
 	# ================================= PROC Etapas

	def rgstrs_mnms?
		self.krn_denunciantes.any? and (self.krn_denunciados.any? or self.violencia?)
	end

 	# Los datos de los participantes ingresados hasta el momento están completos
	def rgstrs_ok?
		self.krn_denunciantes.rgstrs_ok? and (self.krn_denunciados.rgstrs_ok? or self.violencia?)
	end

	def emails_vrfcds?
		self.krn_denunciantes.emails_ok? and (self.krn_denunciados.emails_ok? or self.violencia?)
	end

	# ETAPA Para resolver el comienzo de las etapas
	def rgstrs_info_mnm?
		self.rgstrs_mnms? and self.rgstrs_ok?
	end

 	# Reconocer declaración Verbal: recibida en la empresa, entregada presencial en forma verbal
 	def verbal?
 		self.rcp_empresa? and self.via_declaracion == 'Presencial' and self.tipo_declaracion == 'Verbal'
 	end

 	# TAREA Información obligatoria
 	def get_infrmcn_oblgtr?
 		self.verbal? and self.dnncnt_info_oblgtr.blank?
 	end

 	def dnncnts_info_oblgtr?
 		self.krn_denunciantes.map {|dnncnt| dnncnt.info_oblgtr?}.uniq.join('-') == 'true'
 	end

 	def rcpcn_dnnc?
 		self.on_externa? and (not self.externa?)
 	end

 	def drvcn_extrn?
 		self.on_empresa? and self.externa?
 	end

 	def get_opcns_dnncnt?
 		not (self.on_dt? or self.dnncnt_investigacion_local or self.dnncnt_opcn_escrita)
 	end

 	def get_crr_rcpcn?
 		self.investigacion_local or self.investigacion_externa or self.on_dt?
 	end

 	def get_crr_infrm?
 		self.fecha_trmn? or self.on_dt?
 	end

 	def inf_cierre?
 		self.rgstrs_info_mnm? and (self.dnncnts_info_oblgtr? or self.dnncnt_info_oblgtr) and self.fls_rcpcn?
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

 	def info_rcpcn_sent?
 		self.invstgcn_sents? and self.mdds_rsgrd_sents? and self.ntfcn_drvcns_sents?
 	end

 	# ---------------------------------------------------- ARCHIVOS CONTROLADOS RECEPCION

 	def fl_rprsntcn?
 		self.presentado_por == 'Representante' ? self.fl?('dnncnt_rprsntcn') : true
 	end

 	def fl_atncn_sclgc_tmprn?
 		self.krn_denunciantes.diats_dieps_ok?
 	end

 	def fl_dnnc?
 		self.verbal? ? true : self.fl?('dnnc_denuncia')
 	end

 	def fl_acta?
 		self.verbal? ? self.fl?('dnnc_acta') : true
 	end

 	def mdds_rsgrd_for_attchmnt?
 		lst = fl_last_tkn('mdds_rsgrd', :fecha)
 		lst.present? and lst.archivo.present?
 	end

 	def fl_mdds_rsgrd?
 		self.fl?('mdds_rsgrd')
 	end

 	def fl_ntfccn?
 		self.rcp_dt? ? self.fl?('dnnc_notificacion') : true
 	end

 	def fl_crtfcd?
 		(self.krn_derivaciones.any? and self.on_dt?) ? self.fl?('dnnc_certificado') : true
 	end

 	def fl_rslcn_dvlcn?
 		self.solicitud_denuncia ? self.fl?('rslcn_dvlcn') : true
 	end

 	def fls_rcpcn?
 		self.fl_atncn_sclgc_tmprn? and self.fl_dnnc? and self.fl_acta? and self.fl_mdds_rsgrd? and self.fl_rprsntcn? and self.fl_ntfccn? and fl_crtfcd? and self.fl_rslcn_dvlcn?
 	end

 	# ---------------------------------------------------- ARCHIVOS CONTROLADOS INVESTIGACION

 	def fl_antcdnts_objcn?
 		self.objcn_invstgdr? ? self.fl?('antcdnts_objcn') : true
 	end

 	def fl_rslcn_objcn?
 		self.objcn_invstgdr? ? self.fl?('rslcn_objcn') : true
 	end

 	def fl_evlcn?
 		self.evlcn_incnsstnt ? self.fl?('dnnc_evlcn') : true
 	end

 	def fl_crrgd?
 		self.fecha_hora_corregida? ? self.fl?('dnnc_corrgd') : true
 	end

 	def fl_infrm?
 		self.fl?('infrm_invstgcn')
 	end

 	def fls_invstgcn?
 		self.fl_antcdnts_objcn? and self.fl_rslcn_objcn? and self.fl_evlcn? and self.fl_crrgd? and self.fl_infrm?
 	end

 	# ---------------------------------------------------- ARCHIVOS CONTROLADOS INVESTIGACION

 	def fl_prnncmnt?
 		self.fecha_prnncmnt? ? self.fl?('prnncmnt_dt') : true
 	end

 	# ---------------------------------------------------- 
 	# Sirve para controlar crud de los investigadores
 	def objcn_invstgdr?
 		self.krn_inv_denuncias.any? ? self.krn_inv_denuncias.first.objetado : false
 	end

 	def objcn_ok?
 		self.objcn_invstgdr? ? (self.objcn_rechazada or (self.objcn_acogida and self.krn_inv_denuncias.count == 2)) : true
 	end

 	def dnnc_evld?
 		(self.evlcn_incnsstnt and self.fecha_hora_corregida?) or self.evlcn_ok?
 	end

 	# DEPRECATED
	def dclrcns_ok?
		self.krn_denunciantes.dclrcns? and (self.krn_denunciados.dclrcns? or self.violencia?)
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

 	# ================================= 030_drvcns: Ingreso de la denuncia

	def artcl41?
		self.krn_denunciantes.artcl41.any? or self.krn_denunciados.artcl41.any?
	end

 	# --------------------------------- Despliegue de formularios

 	# Se usa para evitar crear una "derivación" que ya se haya creado en la denuncia
 	def drvcn?(code)
 		self.krn_derivaciones.find_by(codigo: code)
 	end

end