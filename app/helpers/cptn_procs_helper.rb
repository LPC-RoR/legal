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
			etp_rcpcn: ['KrnDenuncia', 'KrnDenunciante', 'KrnDenunciado', 'KrnTestigo'].include?(ownr.class.name),
			etp_invstgcn: ((dnnc.fecha_trmtcn? or  dnnc.fecha_hora_dt?) and dnnc.on_empresa?),
			etp_envio: (( dnnc.fecha_hora_dt? ? dnnc.fecha_trmtcn? : dnnc.fecha_trmn?) or ( not dnnc.on_empresa? )),
			etp_prnncmnt: (dnnc.fecha_env_infrm? and (not dnnc.on_dt?)),
			etp_mdds_sncns: ( dnnc.fecha_env_infrm? or dnnc.prnncmnt_vncd? )
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
			'030_drvcns' => (dnnc.denunciantes? and dnnc.denunciados?),
#			'040_mdds' => ( dnnc.on_dt? or dnnc.investigacion_local or dnnc.investigacion_externa),
			'050_crr' => (dnnc.rgstrs_ok? and (dnnc.dnnc.investigacion_local or dnnc.investigacion_externa or dnnc.fecha_hora_dt? or dnnc.rcp_dt?)),
			# INVSTGCN
			'060_invstgdr' => ((dnnc.fecha_trmtcn? or dnnc.fecha_hora_dt?) and dnnc.on_empresa?),
			'070_evlcn' => (dnnc.krn_inv_denuncias.any? and dnnc.on_empresa?),
			'080_dclrcn' => dnnc.krn_inv_denuncias.any?,
			'090_trmn_invstgcn' => (dnnc.krn_inv_denuncias.any? and dnnc.evlds? and dnnc.on_empresa? and dnnc.rlzds?),
			'100_env_rcpcn' => (dnnc.fecha_trmn? or dnnc.fecha_hora_dt?),
			'110_prnncmnt' => dnnc.fecha_env_infrm?,
			'120_mdds_sncns' => ( dnnc.fecha_env_infrm? or dnnc.prnncmnt_vncd? )
		}
	end

	def tar_trsh_cndtn(ownr)
		case ownr.class.name
		when 'KrnDenuncia'
			{
				'010_ingrs' => ownr.denunciantes?,
				'030_drvcns' => (ownr.fl?('mdds_rsgrd') or ownr.fecha_env_infrm?),
				'050_crr' => ownr.krn_investigadores.any?,
				'070_evlcn' => ownr.declaraciones?,
				'090_trmn_invstgcn' => ownr.fecha_env_infrm?,
				'100_env_rcpcn' => (ownr.fecha_prnncmnt? or ownr.prnncmnt_vncd?),
				'110_prnncmnt' => ownr.fl?('dnnc_mdds_sncns')
			}
		when 'KrnDenunciante'
			{
				'020_prtcpnts' => ownr.rlzd
			}
		when 'KrnDenunciado'
			{
				'020_prtcpnts' => ownr.rlzd
			}
		when 'KrnTestigo'
			{
				'020_prtcpnts' => ownr.rlzd
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

	# Es neesario acceder al plazo sabiendo el código de la etapa
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

	def plz_ok?(fecha, plazo)
		fecha.present? ? plazo.to_date >= fecha.to_date : (plazo.to_date > Time.zone.today.to_date ? nil : false)
	end

	def etp_plz_ok(ownr)
		dnnc = ownr.dnnc
		{
			'etp_rcpcn'      => plz_ok?(dnnc.fecha_trmtcn, dnnc.plz_trmtcn),
			'etp_invstgcn'   => plz_ok?(dnnc.fecha_trmn, dnnc.plz_invstgcn),
			'etp_envio'      => plz_ok?(dnnc.fecha_env_infrm, dnnc.plz_infrm),
			'etp_prnncmnt'   => dnnc.on_dt? ? false : plz_ok?(dnnc.fecha_prnncmnt, dnnc.plz_prnncmnt),
			'etp_mdds_sncns' => plz_ok?(dnnc.fecha_prcsd, dnnc.plz_mdds_sncns),
		}
	end

	def rcptr_lst(formato)
		formato == 'P+' ? ['Empresa', 'Dirección del Trabajo', 'Empresa externa'] : ['Empresa', 'Dirección del Trabajo']
	end

end
