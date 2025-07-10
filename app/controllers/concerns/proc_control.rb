module ProcControl
  extend ActiveSupport::Concern

	# ------------------------------------------------------------------------------------- NEW VERSION

	def etp_cntrl_hsh(ownr, objt)
		dnnc = ownr.dnnc
		{
			'etp_rcpcn'      	=> objt['rgstrs_mnms?'],
			'etp_invstgcn'   	=> ((objt['fechas_crr_rcpcn?'] or objt['on_dt?']) and objt['chck_dvlcn?']),
			'etp_infrm'      	=> (dnnc.fecha_trmn? or dnnc.plz_invstgcn_vncd),
			'etp_prnncmnt'   	=> (dnnc.fecha_env_infrm? or dnnc.fecha_rcpcn_infrm?),
			'etp_mdds_sncns' 	=> ( dnnc.fecha_prnncmnt? or dnnc.prnncmnt_vncd or dnnc.fecha_rcpcn_infrm? ),
			'etp_cierre' 			=> dnnc.fecha_cierre?
		}
	end

	# ------------------------------------------------------------------------------------- PIS

	def etp_hide_hsh(dnnc)
		{
			'etp_prnncmnt' => dnnc.on_dt?
		}
	end

	def etp_hide(dnnc, codigo)
		etp_hide_hsh(dnnc)[codigo].blank? ? false : etp_hide_hsh(dnnc)[codigo]
	end

	def tar_hide_hsh(ownr)
		dnnc = ownr.dnnc
		{
			'060_invstgdr' => dnnc.on_dt?,
			'070_evlcn' => ownr.dnnc.on_dt?,
		}
	end

	def tar_hide(ownr, codigo)
		tar_hide_hsh(ownr)[codigo].blank? ? false : tar_hide_hsh(ownr)[codigo]
	end

end