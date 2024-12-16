module CptnProcsHelper

	# ------------------------------------------------------------------------------------- PIS
	# -----------------------------------------------------------------------------------------

	def dnnc_ownr(ownr)
		clss = ownr.class.name
		clss == 'KrnDenuncia' ? ownr : ( ['KrnDenunciante', 'KrnDenunciado'].include?(clss) ? ownr.krn_denuncia : ownr.ownr.krn_denuncia )
	end

	def etp_cntrl(ownr)
		clss = ownr.class.name
		dnnc = clss == 'KrnDenuncia' ? ownr : ( ['KrnDenunciante', 'KrnDenunciado'].include?(clss) ? ownr.krn_denuncia : ownr.ownr.krn_denuncia )
		dnnc = dnnc_ownr(ownr)
		{
			etp_rcpcn: ['KrnDenuncia', 'KrnDenunciante'].include?(ownr.class.name),
			etp_invstgcn: (dnnc.fecha_ntfccn.present? and @dnnc_jot['on_empresa']),
			etp_envio: @dnnc_jot['envio_ok'],
			etp_prnncmnt: (dnnc.fecha_env_infrm.present? and (not @dnnc_jot['on_dt'])),
			etp_mdds_sncns: (dnnc.fecha_prnncmnt.present? or (dnnc.on_dt? and dnnc.fecha_env_infrm.present?))
		}
	end

	def tar_cntrl(ownr)
		clss = ownr.class.name
		dnnc = clss == 'KrnDenuncia' ? ownr : ( ['KrnDenunciante', 'KrnDenunciado'].include?(clss) ? ownr.krn_denuncia : ownr.ownr.krn_denuncia )
		dnnc = dnnc_ownr(ownr)
		{
			# Ingreso de datos básicos de la Denuncia
			dnnc_ingrs: true,							
			# Ingreso de participantes primarios: Sólo aparece si es necesario llenar empresa del empleado
			dnnc_prtcpnts: (ownr.class.name != 'KrnDenuncia' and (ownr.empleado_externo or ownr.articulo_516)),		
			# Si hay denunciantes, aparece uno para cada denunciante
			dnncnt_diat_diep: (ownr.class.name == 'KrnDenunciante'),	
			# Ingreso terminó y denuncia no fue recibida en la DT		
#			dnnc_drvcn: (dnnc.ingrs_dnnc_bsc? and dnnc.ingrs_nts_ds? and (not dnnc.rcp_dt?)),				
			dnnc_drvcn: (@dnnc_jot['ingrs_dnnc_bsc'] and @dnnc_jot['ingrs_nts_ds'] and (not dnnc.rcp_dt?)),				
			# Sin derivaciones o única recepción | investigacion por la empresa | invetigacion por empresa externa
			dnnc_mdds: ((( not @dnnc_jot['drvcns_any']) and (not dnnc.rcp_externa?)) or (@dnnc_jot['on_empresa'] and @dnnc_jot['vlr_drv_dnncnt_optn'] ) or (@dnnc_jot['on_externa'] and @dnnc_jot['vlr_sgmnt_emprs_extrn'] ) or @dnnc_jot['drv_dt'] ),
			# Registos de "principales" completo
			dnnc_prmr_plz: (@dnnc_jot['ingrs_fls_ok'] and @dnnc_jot['prtcpnts_ok']),
			# INVSTGCN
			dnnc_invstgdr: (dnnc.fecha_trmtcn.present?),
			dnnc_evlcn:  (controller_name == 'KrnDenuncia' and @dnnc_jot['invstgdr_ok'] ),
			dnnc_agndmnt: ((dnnc.fecha_hora_corregida.present? or (@dnnc_jot['vlr_dnnc_eval_ok'] and @dnnc_jot['dnnc_eval_ok'])) and controller_name != 'krn_denuncias'),
			dnnc_dclrcn: (@dnnc_jot['dclrcns_any'] and controller_name != 'krn_denuncias'),
			dnnc_rdccn_infrm: @dnnc_jot['dclrcns_ok'], 
			dnnc_trmn_invstgcn: @dnnc_jot['dclrcns_ok'],
			dnnc_fecha_env: (@dnnc_jot['envio_ok']),
			dnnc_prnncmnt: dnnc.fecha_env_infrm.present?,
			dnnc_mdds_sncns: (dnnc.fecha_prnncmnt.present? or (@dnnc_jot['on_dt'] and dnnc.fecha_env_infrm.present?))

		}
	end

	def get_cndtn(ownr, code, type)
		frst_step = elemnt_cndtns[ownr.class.name].blank? ? nil : elemnt_cndtns[ownr.class.name]
		scnd_step = frst_step.blank? ? nil : (frst_step[code.to_sym].blank? ? nil : frst_step[code.to_sym])
		scnd_step.blank? ? nil : (scnd_step[type].blank? ? nil : scnd_step[type])
	end

	def elemnt_cndtns
		{
			'KrnDenuncia' => {
				externa_id: {
					# La existencia de este campo indica que la denuncia fue presentada en una empresa externa
					# Ingreso básico de la denuncia, se cierra al ingresar el primer denunciante
					cndtn: @dnnc_jot['emprs_extrn_prsnt'],
					trsh: (not @dnnc_jot['dnncnts_any'])
				},
				tipo: {
					# Ingreso básico de la denuncia, se cierra al ingresar el primer denunciante
					# ['Escrita', 'Verbal']
					cndtn: @dnnc_jot['tipo_declaracion_prsnt'],
					trsh: (not @dnnc_jot['dnncnts_any'])
				},
				representante: {
					# Ingreso básico de la denuncia, se cierra al ingresar el primer denunciante
					cndtn: @dnnc_jot['representante_prsnt'],
					trsh: (not @dnnc_jot['dnncnts_any'])
				},
				# DRVCNS
				drv_rcp_externa: {
					# recepción de derivaciones
					# Se vuelve a activar al borrar la derivación
					cndtn: ((@dnnc_jot['drvcns_any']) or @dnnc_jot['vlr_sgmnt_emprs_extrn']),
					trsh: (not @dnnc_jot['vlr_drv_inf_dnncnt'])
				},
				drv_dt_oblgtr: {
					# Se vuelve a activar al borrar la derivación
					cndtn: @dnnc_jot['on_dt'],
					trsh: false
				},
				drv_inf_dnncnt: {
					cndtn: (@dnnc_jot['vlr_drv_inf_dnncnt']),
					trsh: (not (@dnnc_jot['vlr_drv_dnncnt_optn']))
				},
				drv_dnncnt_optn: {
					cndtn: (@dnnc_jot['vlr_drv_dnncnt_optn']),
					trsh: (not (@dnnc_jot['vlr_drv_emprs_optn']))
				},
				drv_emprs_optn: {
					cndtn: (@dnnc_jot['drv_emprs_optn'] or @dnnc_jot['on_dt']),
					trsh: (not (@dnnc_jot['fecha_trmtcn_prsnt'] or @dnnc_jot['fl_mdds_rsgrd']))
				},
				drv_fecha_dt: {
					# Fecha de recepción de la denuncia derivada a la DT
					# Se cierra al recibir informe de investigación de la DT o el rechazo de la derivación
					cndtn: @dnnc_jot['fecha_hora_dt_prsnt'],
					trsh: (not @dnnc_jot['fecha_trmtcn_prsnt'])
				},
				dnnc_fecha_trmtcn: {
					cndtn: @dnnc_jot['fecha_trmtcn_prsnt'],
					trsh: (not @dnnc_jot['frst_invstgdr'])
				},
				dnnc_fecha_ntfccn: {
					# Fecha de Notificación de la denuncia a los participantes
					# Se cierra al recibir informe de investigación de la DT o el rechazo de la derivación
					cndtn: @dnnc_jot['fecha_ntfccn_prsnt'],
					trsh: (not @dnnc_jot['frst_invstgdr'])
				},
				dnnc_invstgdr: {
					cndtn: @dnnc_jot['frst_invstgdr'],
					trsh: (not @dnnc_jot['fecha_ntfccn_invstgdr_prsnt'])
				},
				dnnc_fecha_ntfccn_invstgdr: {
					cndtn: @dnnc_jot['fecha_ntfccn_invstgdr_prsnt'],
					trsh: (not (@dnnc_jot['vlr_dnnc_eval_ok'] or @dnnc_jot['vlr_dnnc_objcn_invstgdr']))
				},
				dnnc_objcn_invstgdr: {
					cndtn: (@dnnc_jot['vlr_dnnc_objcn_invstgdr']),
					trsh: (not (@dnnc_jot['dclrcns_any']))
				},
				dnnc_rslcn_objcn: {
					cndtn: (@dnnc_jot['vlr_dnnc_rslcn_objcn']),
					trsh: (not (@dnnc_jot['vlr_dnnc_eval_ok'] or @dnnc_jot['scnd_invstgdr']))
				},
				dnnc_invstgdr_objcn: {
					cndtn: @dnnc_jot['scnd_invstgdr'],
					trsh: (not @dnnc_jot['vlr_dnnc_eval_ok'])
				},
				dnnc_eval_ok: {
					cndtn: @dnnc_jot['vlr_dnnc_eval_ok'],
					trsh: (not @dnnc_jot['fecha_hora_corregida_present'])
				},
				dnnc_fecha_crrgd: {
					cndtn: @dnnc_jot['fecha_hora_corregida_present'],
					trsh: (not @dnnc_jot['dclrcns_any'])
				},
				dnnc_crr_dclrcns: {
					cndtn: @dnnc_jot['vlr_dnnc_crr_dclrcns'],
					trsh: (not @dnnc_jot['vlr_dnnc_infrm_dt'])
				},
				dnnc_infrm_dt: {
					cndtn: @dnnc_jot['vlr_dnnc_infrm_dt'],
					trsh: (not @dnnc_jot['fecha_trmn_prsnt'])
				},
				dnnc_fecha_trmn: {
					cndtn: @dnnc_jot['fecha_trmn_prsnt'],
					trsh: (not @dnnc_jot['fecha_env_infrm_prsnt'])
				},
				dnnc_fecha_env: {
					cndtn: @dnnc_jot['fecha_env_infrm_prsnt'],
					trsh: (not @dnnc_jot['fecha_prnncmnt_prsnt'])
				},
				dnnc_fecha_prnncmnt: {
					cndtn: @dnnc_jot['fecha_prnncmnt_prsnt'],
					trsh: (not @dnnc_jot['fecha_prcsd_prsnt'])
				},
				dnnc_fecha_mdds_sncns: {
					cndtn: @dnnc_jot['fecha_prcsd_prsnt'],
					trsh: (not false)
				},
			},
			'KrnDenunciante' => {
				externa_id: { 
					cndtn: @dnnc_jot['emprs_extrn_prsnt'], 
					trsh: ( not @dnnc_jot['dnnc_fech_trmitcn'])
				},
				ntfccn: {
					cndtn: @dnnc_jot['drccn_ntfccn_prsnt'],
					trsh: (not @dnnc_jot['dnnc_fech_trmitcn'])
				}
			},
			'KrnDenunciado' => {
				externa_id: { 
					cndtn: @dnnc_jot['emprs_extrn_prsnt'], 
					trsh: ( not @dnnc_jot['dnnc_fech_trmitcn'])
				},
				ntfccn: {
					cndtn: @dnnc_jot['drccn_ntfccn_prsnt'],
					trsh: (not @dnnc_jot['dnnc_fech_trmitcn'])
				}
			}
		}
	end

	def tar_cmpltd_cndtns(dnnc)
		{
			dnnc_ingrs: @dnnc_jot['ingrs_dnnc_bsc'],
		}
	end

	def tar_cmpltd(ownr, code)
		dnnc = dnnc_ownr(ownr)
		code_sym = code.to_sym
		tar_cmpltd_cndtns(dnnc)[code_sym].present? ? tar_cmpltd_cndtns(dnnc)[code_sym] : false
	end

	def dc_fl?(ownr, code)
		dc = RepDocControlado.find_by(codigo: code)
		dc.blank? ? false : ownr.rep_archivos.where(rep_doc_controlado_id: dc.id).present?
	end

	def plz_aplcnm_mddds_sncns(dnnc)
		plz_clcl = dnnc.fecha_env_infrm.blank? ? nil : plz_lv(dnnc.fecha_env_infrm, 30)
		if dnnc.on_dt?
			fch_bs = dnnc.fecha_env_infrm
		else
			fch_bs = dnnc.fecha_env_infrm.blank? ? nil : (dnnc.fecha_prnncmnt.blank? ? plz_clcl : [plz_clcl, dnnc.fecha_prnncmnt].min)
		end
		fch_bs.blank? ? nil : plz_c(fch_bs, 15)
	end

	def etp_plz(ownr)
		dnnc = dnnc_ownr(ownr)
		{
			'etp_rcpcn'      => dnnc.plz_trmtcn,
			'etp_invstgcn'   => dnnc.plz_invstgcn,
			'etp_envio'      => dnnc.plz_infrm,
			'etp_prnncmnt'   => dnnc.plz_prnncmnt,
			'etp_mdds_sncns' => dnnc.plz_mdds_sncns
		}
	end

	def etp_plz_ok(ownr)
		dnnc = dnnc_ownr(ownr)
		{
			'etp_rcpcn'      => dnnc.fecha_trmtcn.blank? ? nil : dnnc.fecha_trmtcn <= dnnc.plz_trmtcn,
			'etp_invstgcn'   => dnnc.fecha_trmn.blank? ? nil : dnnc.fecha_trmn <= dnnc.plz_invstgcn,
			'etp_envio'      => dnnc.fecha_env_infrm.blank? ? nil : dnnc.fecha_env_infrm <= dnnc.plz_infrm,
			'etp_prnncmnt'   => dnnc.fecha_prnncmnt.blank? ? nil : dnnc.fecha_prnncmnt <= dnnc.plz_prnncmnt,
			'etp_mdds_sncns' => dnnc.fecha_prcsd.blank? ? nil : dnnc.fecha_prcsd <= dnnc.plz_mdds_sncns
		}
	end

	def prfx_cntrllr(cdg)
		unless cdg.blank?
			case cdg.split('_')[0]
			when 'dnnc'
				'krn_denuncias'
			end
		else
			nil
		end
	end

	def actvbx_gly
		{
			'Derivación' => 'arrow-up-right',
			'Confirmación' => 'check2-square',
			'Selección' => 'check-square',
			'Recepción' => 'box-arrow-in-down-right',
			'Info' => 'toggle-on',
			'Fecha' => 'calendar2-check',
			'Radio' => 'ui-radios'
		}
	end

	def rcptr_lst(formato)
		formato == 'P+' ? ['Empresa', 'Dirección del Trabajo', 'Empresa externa'] : ['Empresa', 'Dirección del Trabajo']
	end

end
