module DnncProc
 	extend ActiveSupport::Concern

	def prtl_cndtn
		{
			# INGRS_BSC
			# Se cierra cuando se ingresa el primer denunciante
			externa_id: {
				# La existencia de este campo indica que la denuncia fue presentada en una empresa externa
				# Ingreso bàsico de la denuncia, se cierra al ingresar el primer denunciante
				cndtn: self.krn_empresa_externa.present?,
				trsh: (not self.krn_denunciantes.any?)
			},
			tipo: {
				# Ingreso básico de la denuncia, se cierra al ingresar el primer denunciante
				# ['Escrita', 'Verbal']
				cndtn: self.tipo_declaracion.present?,
				trsh: (not self.krn_denunciantes.any?)
			},
			representante: {
				# Ingreso básico de la denuncia, se cierra al ingresar el primer denunciante
				cndtn: self.representante.present?,
				trsh: (not self.krn_denunciantes.any?)
			},
			# DRVCNS
			drv_rcp_externa: {
				# recepción de derivaciones
				# Se vuelve a activar al borrar la derivación
				cndtn: (not self.no_drvcns? or self.vlr_sgmnt_emprs_extrn?),
				trsh: (not self.vlr_drv_inf_dnncnt?)
			},
			drv_dt_oblgtr: {
				# Se vuelve a activar al borrar la derivación
				cndtn: self.on_dt?,
				trsh: false
			},
			drv_inf_dnncnt: {
				cndtn: (self.vlr_drv_inf_dnncnt?),
				trsh: (not (self.vlr_drv_dnncnt_optn?))
			},
			drv_dnncnt_optn: {
				cndtn: (self.vlr_drv_dnncnt_optn?),
				trsh: (not (self.drv_emprs_optn?))
			},
			drv_emprs_optn: {
				cndtn: (self.drv_emprs_optn? or self.drv_dt?),
				trsh: (not (self.fecha_trmtcn.present? or self.fl?('mdds_rsgrd')))
			},
			drv_fecha_dt: {
				# Fecha de recepción de la denuncia derivada a la DT
				# Se cierra al recibir informe de investigación de la DT o el rechazo de la derivación
				cndtn: self.fecha_hora_dt.present?,
				trsh: (not self.fecha_trmtcn.present?)
			},



			dnnc_fecha_trmtcn: {
				cndtn: self.fecha_trmtcn.present?,
				trsh: (not self.krn_investigadores.first.present?)
			},
			dnnc_fecha_ntfccn: {
				# Fecha de Notificación de la denuncia a los participantes
				# Se cierra al recibir informe de investigación de la DT o el rechazo de la derivación
				cndtn: self.fecha_ntfccn.present?,
				trsh: (not self.krn_investigadores.first.present?)
			},

			# INVSTGDR Y OBJCN
			dnnc_invstgdr: {
				cndtn: self.krn_investigadores.first.present?,
				trsh: (not self.fecha_ntfccn_invstgdr.present?)
			},
			dnnc_fecha_ntfccn_invstgdr: {
				cndtn: self.fecha_ntfccn_invstgdr.present?,
				trsh: (not (self.vlr_dnnc_eval_ok? or self.vlr_dnnc_objcn_invstgdr?))
			},
			dnnc_objcn_invstgdr: {
				cndtn: (self.vlr_dnnc_objcn_invstgdr?),
				trsh: (not (self.krn_declaraciones.any?))
			},
			dnnc_rslcn_objcn: {
				cndtn: (self.vlr_dnnc_rslcn_objcn?),
				trsh: (not (self.vlr_dnnc_eval_ok? or self.krn_investigadores.second.present?))
			},
			dnnc_invstgdr_objcn: {
				cndtn: self.krn_investigadores.second.present?,
				trsh: (not self.vlr_dnnc_eval_ok?)
			},
			# EVALCN
			dnnc_eval_ok: {
				cndtn: self.vlr_dnnc_eval_ok?,
				trsh: (not self.fecha_hora_corregida.present?)
			},
			dnnc_fecha_crrgd: {
				cndtn: self.fecha_hora_corregida.present?,
				trsh: (not self.any_dclrcn?)
			},
			dnnc_crr_dclrcns: {
				cndtn: self.vlr_dnnc_crr_dclrcns?,
				trsh: (not self.vlr_dnnc_infrm_dt?)
			},
			dnnc_infrm_dt: {
				cndtn: self.vlr_dnnc_infrm_dt?,
				trsh: (not self.fecha_trmn.present?)
			},

			dnnc_fecha_trmn: {
				cndtn: self.fecha_trmn.present?,
				trsh: (not self.fecha_env_infrm.present?)
			},
			dnnc_fecha_env: {
				cndtn: self.fecha_env_infrm.present?,
				trsh: (not self.fecha_prnncmnt.present?)
			},
			dnnc_fecha_prnncmnt: {
				cndtn: self.fecha_prnncmnt.present?,
				trsh: (not self.fecha_prcsd.present?)
			},
			dnnc_fecha_mdds_sncns: {
				cndtn: self.fecha_prcsd.present?,
				trsh: (not false)
			},
		}
	end

	# ingreso de campos básicos ok?
	def ingrs_dnnc_bsc?
		extrn = self.receptor_denuncia == 'Empresa externa' ? self.krn_empresa_externa_id.present? : true
		rprsntnt = self.presentado_por == 'Representante' ? self.representante.present? : true
		tp = self.via_declaracion == 'Presencial' ? self.tipo_declaracion.present? : true
		extrn and rprsntnt and tp
	end

	def dnncnts?
		self.krn_denunciantes.any?
	end

	def dnncds?
		self.krn_denunciados.any?
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

	def no_drvcns?
		self.krn_derivaciones.empty?
	end

	def drvcn_rcbd?
		self.krn_derivaciones.empty? ? false : self.krn_derivaciones.first.destino == 'Empresa'
	end

	def just_rcvd?
		self.krn_derivaciones.count == 1 and self.krn_derivaciones.first.destino == 'Empresa'
	end

	def invstgdr_ok?
		(self.vlr_dnnc_objcn_invstgdr? and self.dnnc_objcn_invstgdr?) ? self.krn_investigadores.second.present? : self.krn_investigadores.first.present?
	end

	def dclrcns_ok?
		self.krn_declaraciones.map {|dclrcn| dclrcn.rlzd == true}.exclude?(false)
	end



	def ingrs_dnncds_ok?
		self.krn_denunciados.rgstrs_ok?
	end

	def ingrs_drvcns?
		self.drv_emprs_optn? or self.on_externa? or self.on_dt?
	end

	def fl?(code)
		dc = RepDocControlado.get_dc(code)
		self.rep_archivos.find_by(rep_doc_controlado_id: dc.id).present?
	end

	#--------------------------------------------------------------------------- METHODS

	def ingrs_fls_ok?
		cods = ['mdds_rsgrd']
		cods.push('dnnc_denuncia') if self.tipo_declaracion != 'Verbal'
		cods.push('dnnc_acta') if self.tipo_declaracion == 'Verbal'
		cods.push('dnncnt_rprsntcn') if self.presentado_por == 'Representante'
		cods.push('dnnc_certificado') if self.drv_dt? == true
		cods.push('dnnc_notificacion') if self.rcp_dt?

		cds = cods.map {|code| RepDocControlado.get_dc(code)}
		fls_ok = cds.map {|dc| self.rep_archivos.find_by(rep_doc_controlado_id: dc.id).present?}.exclude?(false)

		fls_ok and self.krn_denunciantes.diats_dieps_ok?
	end

	def dnnc_crrgd?
		RepDocControlado.get_dc('dnnc_corrgd').present?
	end

	def ntfccn_invstgdr?
		self.fecha_ntfccn_invstgdr.present?
	end

	def infrm_rdctd?
		cods = ['infrm_invstgcn', 'mdds_crrctvs', 'sncns']
		cds = cods.map {|code| RepDocControlado.get_dc(code)}
		cds.map {|dc| self.rep_archivos.find_by(rep_doc_controlado_id: dc.id).present?}.exclude?(false)
	end

	def envio_ok?
		self.fecha_trmn.present? or (self.on_dt? and self.fecha_trmtcn.present?)
	end

end