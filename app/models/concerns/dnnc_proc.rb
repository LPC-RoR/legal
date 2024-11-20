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
				# Ingreso bàsico de la denuncia, se cierra al ingresar el primer denunciante
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
				cndtn: (not self.no_drvcns?),
				trsh: false
			},
			drv_dt_oblgtr: {
				# Se vuelve a activar al borrar la derivación
				cndtn: self.on_dt?,
				trsh: false
			},
			drv_inf_dnncnt: {
				cndtn: (self.vlr_drv_inf_dnncnt?),
				trsh: (not (self.vlr_drv_dnncnt_optn? or self.drvcns?))
			},
			drv_dnncnt_optn: {
				cndtn: (self.vlr_drv_dnncnt_optn?),
				trsh: (not (self.drv_emprs_optn? or self.drvcns?))
			},
			drv_emprs_optn: {
				cndtn: (self.drv_emprs_optn? or self.drv_dt?),
				trsh: (not (self.fecha_trmtcn.present? or self.drvcns?))
			},
			drv_fecha_dt: {
				# Fecha de recepción de la denuncia derivada a la DT
				# Se cierra al recibir informe de investigación de la DT o el rechazo de la derivación
				cndtn: self.fecha_hora_dt.present?,
				trsh: (not self.fecha_trmtcn.present?)
			},
			dnnc_fecha_trmtcn: {
				cndtn: self.fecha_trmtcn.present?,
				trsh: (not self.invstgdr?)
			},
			# INVSTGDR Y OBJCN
			invstgdr: {
				cndtn: self.invstgdr?,
				trsh: (not self.fecha_hora_ntfccn_invsgdr.present?)
			},
			dnnc_fecha_ntfccn_invstgdr: {
				cndtn: self.fecha_hora_ntfccn_invsgdr.present?,
				trsh: (not (self.vlr_dnnc_leida? or self.vlr_dnnc_objcn_invstgdr?))
			},
			dnnc_objcn_invstgdr: {
				cndtn: (self.vlr_dnnc_objcn_invstgdr?),
				trsh: (not self.vlr_dnnc_leida?)
			},
			# EVALCN
			dnnc_leida: {
				cndtn: self.vlr_dnnc_leida?,
				trsh: (not self.vlr_dnnc_incnsstnt?)
			},
			dnnc_incnsstnt: {
				cndtn: self.vlr_dnnc_incnsstnt?,
				trsh: (not self.vlr_dnnc_incmplt?)
			},
			dnnc_incmplt: {
				cndtn: self.vlr_dnnc_incmplt?,
				trsh: (not (self.any_dclrcn? or self.fecha_hora_corregida.present?))
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
				trsh: (not false)
			},
			dnnc_fecha_prnncmnt: {
				cndtn: self.fecha_prnncmnt.present?,
				trsh: (not false)
			},
		}
	end

	def ingrs_dnnc_bsc?
		extrn = self.receptor_denuncia == 'Empresa externa' ? self.krn_empresa_externa_id.present? : true
		rprsntnt = self.presentado_por == 'Representante' ? self.representante.present? : true
		tp = self.via_declaracion == 'Presencial' ? self.tipo_declaracion.present? : true
		extrn and rprsntnt and tp
	end

	def ingrs_dnncnts_ok?
		self.krn_denunciantes.rgstrs_ok?
	end

	def ingrs_dnncds_ok?
		self.krn_denunciados.rgstrs_ok?
	end

	def ingrs_drvcns?
		self.drv_emprs_optn? or self.on_externa? or self.on_dt?
	end

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
		self.fecha_hora_ntfccn_invsgdr.present?
	end

	def dclrcns_ok?
		self.krn_denunciantes.dclrcns_ok? and self.krn_denunciados.dclrcns_ok?
	end

	def infrm_rdctd?
		cods = ['infrm_invstgcn', 'mdds_crrctvs', 'sncns']
		cds = cods.map {|code| RepDocControlado.get_dc(code)}
		cds.map {|dc| self.rep_archivos.find_by(rep_doc_controlado_id: dc.id).present?}.exclude?(false)
	end

	def envio_ok?
		self.fecha_trmn.present?
	end

end