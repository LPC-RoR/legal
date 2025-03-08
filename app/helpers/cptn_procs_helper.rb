module CptnProcsHelper

	# ------------------------------------------------------------------------------------- PIS

	def dnnc_ownr(ownr)
		clss = ownr.class.name
		clss == 'KrnDenuncia' ? ownr : ( ['KrnDenunciante', 'KrnDenunciado'].include?(clss) ? ownr.krn_denuncia : ownr.ownr.krn_denuncia )
	end

	def etp_cntrl(ownr)
		clss = ownr.class.name
		dnnc = clss == 'KrnDenuncia' ? ownr : ( ['KrnDenunciante', 'KrnDenunciado'].include?(clss) ? ownr.krn_denuncia : ownr.ownr.krn_denuncia )
		dnnc = dnnc_ownr(ownr)
		{
			etp_rcpcn: ['KrnDenuncia', 'KrnDenunciante', 'KrnDenunciado'].include?(ownr.class.name),
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
			'010_ingrs' => true,
			'020_prtcpnts' => true,
			'030_drvcns' => dnnc.rgstrs_rvsds?,
			'040_mdds' => (( dnnc.rgstrs_rvsds? and ( not dnnc.on_empresa? ) ) or dnnc.investigacion_local),
			'050_crr' => dnnc.fl?('mdds_rsgrd'),
			# Registos de "principales" completo
			dnnc_prmr_plz: (@dnnc_jot['ingrs_fls_ok'] and @dnnc_jot['prtcpnts_ok']),
			# INVSTGCN
			dnnc_invstgdr: (dnnc.fecha_trmtcn.present?),
			dnnc_evlcn:  (controller_name == 'krn_denuncias' and @dnnc_jot['invstgdr_ok'] ),
			dnnc_agndmnt: ((dnnc.fecha_hora_corregida.present? or (@dnnc_jot['vlr_dnnc_eval_ok'] and @dnnc_jot['dnnc_eval_ok'])) and controller_name != 'krn_denuncias'),
			dnnc_dclrcn: (@dnnc_jot['dclrcns_any'] and controller_name != 'krn_denuncias'),
			dnnc_rdccn_infrm: @dnnc_jot['dclrcns_ok'], 
			dnnc_trmn_invstgcn: @dnnc_jot['dclrcns_ok'],
			dnnc_fecha_env: (@dnnc_jot['envio_ok']),
			dnnc_prnncmnt: dnnc.fecha_env_infrm.present?,
			dnnc_mdds_sncns: (dnnc.fecha_prnncmnt.present? or (@dnnc_jot['on_dt'] and dnnc.fecha_env_infrm.present?))

		}
	end

	def tar_trsh_cndtn(ownr)
		case ownr.class.name
		when 'KrnDenuncia'
			{
				'010_ingrs' => ownr.krn_denunciantes.any?,
				'030_drvcns' => ownr.fl?('mdds_rsgrd')
			}
		when 'KrnDenunciante'
			{
				'020_prtcpnts' => ownr.registro_revisado
			}
		when 'KrnDenunciado'
			{
				'020_prtcpnts' => ownr.registro_revisado
			}
		end
	end

	def trsh_cndtn(objeto, ownr)
		case objeto.class.name
		when 'Tarea'
			tar_trsh_cndtn(ownr).blank? ? false : ( tar_trsh_cndtn(ownr)[objeto.codigo].blank? ? false : tar_trsh_cndtn(ownr)[objeto.codigo] ) 
		else
			false
		end
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

	def rcptr_lst(formato)
		formato == 'P+' ? ['Empresa', 'Dirección del Trabajo', 'Empresa externa'] : ['Empresa', 'Dirección del Trabajo']
	end

end
