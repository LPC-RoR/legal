module DnncProc
 	extend ActiveSupport::Concern

	# --------------------------------------------------------------------------- JOT (JUST ONE TIME)
	# se usa sólo en dt_obligatoria'
	def prsncl?
		self.via_declaracion == 'Presencial'
	end

	def prtcpnts_ok?
		self.krn_denunciantes.rgstrs_ok? and self.krn_denunciados.rgstrs_ok?
	end

	def dnncnts_any?
		self.krn_denunciantes.any?
	end

	def drvcns_any?
		self.krn_derivaciones.any?
	end

	def dclrcns_any?
		self.krn_declaraciones.any?
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

	# ingreso de campos básicos ok?
	def ingrs_dnnc_bsc?
		extrn = self.rcp_externa? ? self.krn_empresa_externa_id.present? : true
		rprsntnt = self.presentado_por == 'Representante' ? self.representante.present? : true
		tp = self.via_declaracion == 'Presencial' ? self.tipo_declaracion.present? : true
		extrn and rprsntnt and tp
	end

	def mtv_vlnc?
		self.motivo_denuncia == KrnDenuncia::MOTIVOS[2]
	end

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
		self.dnncnts_rgstrs_ok? and self.krn_denunciados.any?
	end

	def drvcn_rcbd?
		self.krn_derivaciones.empty? ? false : self.krn_derivaciones.first.destino == 'Empresa'
	end

	def invstgdr_ok?
		(self.vlr_dnnc_objcn_invstgdr? and self.dnnc_objcn_invstgdr? == true) ? self.krn_investigadores.second.present? : self.krn_investigadores.first.present?
	end

	def dclrcns_ok?
		self.krn_declaraciones.any? and self.krn_declaraciones.map {|dclrcn| dclrcn.rlzd == true}.exclude?(false)
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