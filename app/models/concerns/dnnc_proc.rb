module DnncProc
 	extend ActiveSupport::Concern
 	# ================================= PROC Etapas

	# El motivo de la denuncia es Violencia... Usado para saber si se ingresan personas denunciadas
	def motivo_vlnc?	# Ocupado sólo una vez
		self.motivo_denuncia == KrnDenuncia::MOTIVOS[2]
	end

	def rgstrs_mnms?
		self.krn_denunciantes.any? and (self.krn_denunciados.any? or self.motivo_vlnc?)
	end

 	# Los datos de los participantes ingresados hasta el momento están completos
	def rgstrs_ok?
		self.krn_denunciantes.rgstrs_ok? and (self.krn_denunciados.rgstrs_ok? or self.motivo_vlnc?)
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

 	def inf_cierre?
 		self.rgstrs_info_mnm? and (self.dnncnts_info_oblgtr? or self.dnncnt_info_oblgtr) and self.fls_rcpcn?
 	end

 	def fechas_crr_rcpcn?
 		self.fecha_trmtcn? or self.fecha_ntfccn? or (self.solicitud_denuncia ? self.fecha_dvlcn? : self.fecha_hora_dt?)
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

 	def fl_mdds_rsgrd?
 		self.fl?('mdds_rsgrd')
 	end

 	def fl_ntfccn?
 		self.rcp_dt? ? self.fl?('dnnc_notificacion') : true
 	end

 	def fl_crtfcd?
 		self.krn_derivaciones.any? and self.on_dt? ? self.fl?('dnnc_certificado') : true
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
 		(self.evlcn_incmplt or self.evlcn_incnsstnt) ? self.fl?('dnnc_evlcn') : true
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
 		((self.evlcn_incmplt or self.evlcn_incnsstnt) and self.fecha_hora_corregida?) or self.evlcn_ok?
 	end

	def dclrcns_ok?
		self.krn_denunciantes.dclrcns? and (self.krn_denunciados.dclrcns? or self.motivo_vlnc?)
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