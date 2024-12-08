module CptnProcsHelper

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
			etp_invstgcn: (dnnc.fecha_ntfccn.present? and dnnc.on_empresa?),
			etp_envio: dnnc.envio_ok?,
			etp_prnncmnt: (dnnc.fecha_env_infrm.present? and (not dnnc.on_dt?)),
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
			dnnc_drvcn: (dnnc.ingrs_dnnc_bsc? and dnnc.ingrs_nts_ds? and (not dnnc.rcp_dt?)),				
			# Sin derivaciones o única recepción | investigacion por la empresa | invetigacion por empresa externa
			dnnc_mdds: ((dnnc.no_drvcns? and (not dnnc.rcp_externa?)) or (dnnc.on_empresa? and dnnc.vlr_drv_dnncnt_optn?) or (dnnc.on_externa? and dnnc.vlr_sgmnt_emprs_extrn?) or dnnc.drv_dt?),
			# Registos de "principales" completo
			dnnc_prmr_plz: (dnnc.ingrs_fls_ok? and dnnc.prtcpnts_ok?),
			# INVSTGCN
			dnnc_invstgdr: (dnnc.fecha_trmtcn.present?),
			dnnc_evlcn:  (controller_name == 'KrnDenuncia' and ownr.invstgdr_ok? ),
			dnnc_agndmnt: ((dnnc.fecha_hora_corregida.present? or (dnnc.vlr_dnnc_eval_ok? and dnnc.dnnc_eval_ok?)) and controller_name != 'krn_denuncias'),
			dnnc_dclrcn: (ownr.krn_declaraciones.any? and controller_name != 'krn_denuncias'),
			dnnc_rdccn_infrm: dnnc.dclrcns_ok?, 
#			dnnc_trmn_invstgcn: (dnnc.infrm_rdctd? or (dnnc.on_dt? and dnnc.ingrs_dnnc_bsc?)),
			dnnc_trmn_invstgcn: dnnc.dclrcns_ok?,
			dnnc_fecha_env: (dnnc.envio_ok?),
			dnnc_prnncmnt: dnnc.fecha_env_infrm.present?,
			dnnc_mdds_sncns: (dnnc.fecha_prnncmnt.present? or (dnnc.on_dt? and dnnc.fecha_env_infrm.present?))

#			dnnc_crr_dclrcns: dnnc.dclrcn?,
#			dnnc_infrm: (dnnc.vlr_dnnc_crr_dclrcns? or dnnc.sgmnt?),
#			dnnc_sncns: (dnnc.vlr_dnnc_crr_dclrcns? or dnnc.sgmnt?),
#			dnnc_infrm_dt: (dnnc.invstgcn_emprs? and dnnc.sncns?),
#			dnnc_prnncmnt: dnnc.fecha_trmtcn.present?
		}
	end

	def tar_cmpltd_cndtns(dnnc)
		{
			dnnc_ingrs: dnnc.ingrs_dnnc_bsc?,
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
