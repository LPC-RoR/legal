module CptnProcsHelper


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

	def hide_last_crud?(codigo, ownr)
		last_crud_hsh = {
			'070_evlcn' => (not ownr.objcn_invstgdr?)
		}
		last_crud_hsh.keys.include?(codigo) ? last_crud_hsh[codigo] : false
	end

	def etp_muted(codigo, ownr)
		etp_mtd_hsh = {
			'etp_invstgcn' => ownr.on_dt?,
			'etp_prnncmnt' => ownr.prnncmnt_vncd
		}
		etp_mtd_hsh.keys.include?(codigo) ? etp_mtd_hsh[codigo] : false
	end

	def etp_hide(codigo, ownr)
		etp_hd_hsh = {
			'etp_prnncmnt' => ownr.on_dt?,
		}
		etp_hd_hsh.keys.include?(codigo) ? etp_hd_hsh[codigo] : false
	end

end
