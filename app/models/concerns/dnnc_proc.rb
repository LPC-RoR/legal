module DnncProc
 	extend ActiveSupport::Concern
 	# ================================= PROC Etapas y Tareas

 	def fechas_invstgcn?
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



	# --------------------------------------------------------------------------- JOT (JUST ONE TIME)
	# se usa sólo en dt_obligatoria'
	def prsncl?
		self.via_declaracion == 'Presencial'
	end

	def prtcpnts_ok?
		self.krn_denunciantes.rgstrs_ok? and self.krn_denunciados.rgstrs_ok?
	end

	def frst_invstgdr?
		self.krn_investigadores.first.present?
	end

	def scnd_invstgdr?
		self.krn_investigadores.second.present?
	end

	def tipo_declaracion_prsnt?
		self.tipo_declaracion.present?
	end

	def representante_prsnt?
		self.representante.present?
	end

	def fecha_trmtcn_prsnt?
		self.fecha_trmtcn.present?
	end

	def fecha_hora_dt_prsnt?
		self.fecha_hora_dt.present?
	end

	def fecha_ntfccn_prsnt?
		self.fecha_ntfccn.present?
	end

	def fecha_ntfccn_invstgdr_prsnt?
		self.fecha_ntfccn_invstgdr.present?
	end

	def fecha_hora_corregida_prsnt?
		self.fecha_hora_corregida.present?
	end

	def fecha_trmn_prsnt?
		self.fecha_trmn.present?
	end

	def fecha_env_infrm_prsnt?
		self.fecha_env_infrm.present?
	end

	def fecha_prnncmnt_prsnt?
		self.fecha_prnncmnt.present?
	end

	def fecha_prcsd_prsnt?
		self.fecha_prcsd.present?
	end

	def envio_ok?
		self.fecha_trmn.present? or (self.on_dt? and self.fecha_trmtcn.present?)
	end

	def dnncds_any?
		self.krn_denunciados.any?
	end


	# -----------------------------------------------------------------------------------------------

	def no_vlnc?
		self.motivo_denuncia != KrnDenuncia::MOTIVOS[2]
	end

	def dnncds_rgstrs_ok?
		self.krn_denunciados.rgstrs_ok?
	end

	def dnncnts_rgstrs_ok?
		self.krn_denunciantes.rgstrs_ok?
	end

	def diat_diep_ok?
		self.krn_denunciantes.diats_dieps_ok?
	end

	def ingrs_nts_ds?
		self.dnncnts_rgstrs_ok? and self.denunciados?
	end

	def drvcn_rcbd?
		self.krn_derivaciones.empty? ? false : self.krn_derivaciones.first.destino == 'Empresa'
	end

	def invstgdr_ok?
		(self.vlr_dnnc_objcn_invstgdr? and self.dnnc_objcn_invstgdr? == true) ? self.krn_investigadores.second.present? : self.krn_investigadores.first.present?
	end

	def dclrcns_ok?
		self.declaraciones? and self.krn_declaraciones.map {|dclrcn| dclrcn.rlzd == true}.exclude?(false)
	end



	#--------------------------------------------------------------------------- METHODS

	def ingrs_fls_ok?
		cods = ['mdds_rsgrd']
		cods.push('dnnc_denuncia') if self.tipo_declaracion != 'Verbal'
		cods.push('dnnc_acta') if self.tipo_declaracion == 'Verbal'
		cods.push('dnncnt_rprsntcn') if self.presentado_por == 'Representante'
		cods.push('dnnc_certificado') if self.drv_dt?
		cods.push('dnnc_notificacion') if self.rcp_dt?

		cds = cods.map {|code| RepDocControlado.get_dc(code)}
		fls_ok = cds.map {|dc| self.rep_archivos.find_by(rep_doc_controlado_id: dc.id).present?}.exclude?(false)

		fls_ok and self.krn_denunciantes.diats_dieps_ok?
	end

end