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

end
