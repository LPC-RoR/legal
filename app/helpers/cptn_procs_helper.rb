module CptnProcsHelper

	# ------------------------------------------------------------------------------------- PIS

	def etp_hide_hsh(ownr)
		{
			etp_prnncmnt: ownr.dnnc.on_dt?,
		}
	end

	def etp_hide(ownr, codigo)
		etp_hide_hsh(ownr)[codigo.to_sym].blank? ? false : etp_hide_hsh(ownr)[codigo.to_sym]
	end

	def etp_cntrl(ownr)
		dnnc = ownr.dnnc
		{
			etp_rcpcn: ['KrnDenuncia', 'KrnDenunciante', 'KrnDenunciado'].include?(ownr.class.name),
			etp_invstgcn: (dnnc.fecha_trmtcn? or  dnnc.fecha_hora_dt?),
			etp_envio: ( dnnc.fecha_hora_dt? ? dnnc_ondnnc.fecha_trmtcn? : dnnc.fecha_trmn?),
			etp_prnncmnt: (dnnc.fecha_env_infrm? and (not dnnc.on_dt?)),
			etp_mdds_sncns: ( dnnc.fecha_env_infrm? or dnnc.plz_prnncmnt_vncd? )
		}
	end

	def tar_hide_hsh(ownr)
		{
			'060_invstgdr' => ownr.dnnc.on_dt?,
			'070_evlcn' => ownr.dnnc.on_dt?,
		}
	end

	def tar_hide(ownr, codigo)
		tar_hide_hsh(ownr)[codigo].blank? ? false : tar_hide_hsh(ownr)[codigo]
	end

	def tar_cntrl(ownr)
		dnnc = ownr.dnnc
		{
			'010_ingrs' => true,
			'020_prtcpnts' => true,
			'030_drvcns' => dnnc.rgstrs_rvsds?,
			'040_mdds' => (( dnnc.rgstrs_rvsds? and ( not dnnc.on_empresa? ) ) or dnnc.investigacion_local),
			'050_crr' => dnnc.fl?('mdds_rsgrd'),
			# INVSTGCN
			'060_invstgdr' => ((dnnc.fecha_trmtcn? or dnnc.fecha_hora_dt?) and dnnc.on_empresa?),
			'070_evlcn' => (dnnc.krn_inv_denuncias.any? and dnnc.on_empresa?),
			'080_agndmnt' => dnnc.krn_inv_denuncias.any?,
			'090_trmn_invstgcn' => (dnnc.krn_inv_denuncias.any? and dnnc.rlzds? and dnnc.on_empresa?),
			'100_env_rcpcn' => (dnnc.fecha_trmn? or dnnc.fecha_hora_dt?),
			'110_prnncmnt' => dnnc.fecha_env_infrm?,
			'120_mdds_sncns' => ( dnnc.fecha_env_infrm? or dnnc.plz_prnncmnt_vncd? )
		}
	end

	def tar_trsh_cndtn(ownr)
		case ownr.class.name
		when 'KrnDenuncia'
			{
				'010_ingrs' => ownr.krn_denunciantes.any?,
				'030_drvcns' => ownr.fl?('mdds_rsgrd'),
				'050_crr' => ownr.krn_investigadores.any?,
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

	def etp_plz(ownr)
		dnnc = ownr.dnnc
		{
			'etp_rcpcn'      => dnnc.plz_trmtcn,
			'etp_invstgcn'   => dnnc.plz_invstgcn,
			'etp_envio'      => dnnc.plz_infrm,
			'etp_prnncmnt'   => dnnc.plz_prnncmnt,
			'etp_mdds_sncns' => dnnc.plz_mdds_sncns
		}
	end

	def etp_plz_ok(ownr)
		dnnc = ownr.dnnc
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
