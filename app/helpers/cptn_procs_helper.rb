module CptnProcsHelper

	def etp_cntrl(ownr)
		clss = ownr.class.name
		dnnc = clss == 'KrnDenuncia' ? ownr : ( ['KrnDenunciante', 'KrnDenunciado'].include?(clss) ? ownr.krn_denuncia : ownr.ownr.krn_denuncia )
		{
			etp_rcpcn: ['KrnDenuncia', 'KrnDenunciante'].include?(ownr.class.name),
			etp_invstgcn: dnnc.fecha_trmtcn.present?,
			etp_envio: dnnc.envio_ok?,
			etp_prnncmnt: dnnc.fecha_env_infrm.present?,
			etp_mdds_sncns: dnnc.fecha_prnncmnt.present?
		}
	end

	def tar_cntrl(ownr)
		clss = ownr.class.name
		dnnc = clss == 'KrnDenuncia' ? ownr : ( ['KrnDenunciante', 'KrnDenunciado'].include?(clss) ? ownr.krn_denuncia : ownr.ownr.krn_denuncia )
		{
			# Ingreso de datos básicos de la Denuncia
			dnnc_ingrs: true,							
			# Ingreso de participantes primarios: Sólo aparece si es necesario llenar empresa del empleado
			dnnc_prtcpnts: (ownr.class.name != 'KrnDenuncia' and ownr.empleado_externo),		
			# Si hay denunciantes, aparece uno para cada denunciante
			dnncnt_diat_diep: (ownr.class.name == 'KrnDenunciante'),	
			# Ingreso terminó y denuncia no fue recibida en la DT		
			dnnc_drvcn: (dnnc.ingrs_dnnc_bsc? and (not dnnc.rcp_dt?)),				
			# No es necesario que denunciados estén completos aún
			dnnc_mdds: dnnc.ingrs_drvcns?,
			# Registos de "principales" completo
			dnnc_infrm_invstgcn_dt: (dnnc.ingrs_fls_ok? and dnnc.prtcpnts_ok?),
			# INVSTGCN
			dnnc_invstgdr: (dnnc.fecha_trmtcn.present?),
			dnnc_evlcn: dnnc.invstgdr?,
			dnnc_agndmnt: (dnnc.eval? and controller_name != 'krn_denuncias'),
			dnnc_dclrcn: (ownr.krn_declaraciones.any? and dnnc.dnnc_ok? and controller_name != 'krn_denuncias'),
			dnnc_rdccn_infrm: dnnc.dclrcns_ok?, 
			dnnc_trmn_invstgcn: dnnc.infrm_rdctd?,
			dnnc_fecha_env: dnnc.fecha_trmn.present?,
			dnnc_fecha_prnncmnt: dnnc.fecha_env_infrm.present?,
			dnnc_mdds_sncns: dnnc.fecha_prnncmnt.present?

#			dnnc_crr_dclrcns: dnnc.dclrcn?,
#			dnnc_infrm: (dnnc.vlr_dnnc_crr_dclrcns? or dnnc.sgmnt?),
#			dnnc_sncns: (dnnc.vlr_dnnc_crr_dclrcns? or dnnc.sgmnt?),
#			dnnc_infrm_dt: (dnnc.invstgcn_emprs? and dnnc.sncns?),
#			dnnc_prnncmnt: dnnc.fecha_trmtcn.present?
		}
	end

	def dc_fl?(ownr, code)
		dc = RepDocControlado.find_by(codigo: code)
		dc.blank? ? false : ownr.rep_archivos.where(rep_doc_controlado_id: dc.id).present?
	end

	def ownr_dnnc(ownr)
		ownr.class.name == 'KrnDenuncia' ? ownr : (['KrnDenunciante', 'KrnDenunciado'].include?(ownr.class.name) ? ownr.krn_denuncia : ownr.ownr.krn_denuncia)
	end

	def plz_aplcnm_mddds_sncns(dnnc)
		fch_bs = dnnc.fecha_prnncmnt.blank? ? nil : (dnnc.fecha_prnncmnt < plz_lv(dnnc.fecha_env_infrm, 30) ? dnnc.fecha_prnncmnt : plz_lv(dnnc.fecha_env_infrm, 30))
		fch_bs.blank? ? nil : plz_c(fch_bs, 15)
	end

	def etp_plz(ownr)
		dnnc = ownr_dnnc(ownr)
		{
			'etp_rcpcn'      => plz_lv(dnnc.fecha_hora, 3),
			'etp_invstgcn'   => plz_lv(dnnc.fecha_legal, 30),
			'etp_envio'      => plz_lv(dnnc.fecha_legal, 32),
			'etp_prnncmnt'   => plz_lv(dnnc.fecha_env_infrm, 30),
			'etp_mdds_sncns' => plz_aplcnm_mddds_sncns(dnnc)
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
