module ProcControl
  extend ActiveSupport::Concern

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
			etp_rcpcn: true,					# Se despliega en todos los OWNR
#			etp_invstgcn: (dnnc.fechas_invstgcn? and @proc[:etp_rcpcn][:fls_mss].empty?),
			etp_invstgcn: (dnnc.fechas_invstgcn?),
			etp_envio: (dnnc.fecha_trmn? or dnnc.on_dt?),
			etp_prnncmnt: (dnnc.fecha_env_infrm? and (not dnnc.on_dt?)),
			etp_mdds_sncns: ( dnnc.fecha_prnncmnt? or dnnc.prnncmnt_vncd? or dnnc.fecha_rcpcn_infrm? )
		}
	end

	def tar_hide_hsh(ownr)
		dnnc = ownr.dnnc
		{
			'010_ingrs'    => dnnc.tar_ingrs_ok?,
			'020_prtcpnts' => (ownr != dnnc and ownr.rgstr_ok?),
			'060_invstgdr' => dnnc.on_dt?,
			'070_evlcn' => ownr.dnnc.on_dt?,
		}
	end

	def tar_hide(ownr, codigo)
		tar_hide_hsh(ownr)[codigo].blank? ? false : tar_hide_hsh(ownr)[codigo]
	end

	def tar_cntrl(ownr)
		dnnc = ownr.dnnc
		{
			# Revisar relación con participantes
			'010_ingrs' => (dnnc == ownr),
			'020_prtcpnts' => dnnc != ownr,
			'030_drvcns' => (dnnc.denunciantes? and dnnc.denunciados?),
#			'040_mdds' => ( dnnc.on_dt? or dnnc.investigacion_local or dnnc.investigacion_externa),
			'050_crr' => (dnnc.rgstrs_ok? and (dnnc.investigacion_local or dnnc.investigacion_externa or dnnc.fecha_hora_dt? or dnnc.rcp_dt?)),
			# INVSTGCN
#			'060_invstgdr' => ((dnnc.fechas_invstgcn?) and @proc[:etp_rcpcn][:fls_mss].empty?),
			'060_invstgdr' => ((dnnc.fechas_invstgcn?)),
			'070_evlcn' => (dnnc.investigadores?),
			'080_dclrcn' => (dnnc.investigadores? and dnnc.evld?),
			'090_trmn_invstgcn' => (dnnc.rlzds? or dnnc.on_dt?),
			'100_env_rcpcn' => (dnnc.fecha_trmn? or dnnc.on_dt?),
			'110_prnncmnt' => (dnnc.fecha_env_infrm? and (not dnnc.on_dt?)),
			'120_mdds_sncns' => ( dnnc.fecha_prnncmnt? or dnnc.prnncmnt_vncd? or dnnc.fecha_rcpcn_infrm? )
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
end