module ProcControl
  extend ActiveSupport::Concern

	# ------------------------------------------------------------------------------------- NEW VERSION

	def etp_cntrl_hsh(ownr, objt)
		dnnc = ownr.dnnc
		{
			'etp_rcpcn'      => {
				actv: objt['rgstrs_mnms?'],
				# rgstrs_ok?				: la información de los participantes ingresados hasta el momento está completa.
				# fechas_invstgcn?	: Tramitación, Certificado, Notificación, Devolución
				# chck_dvlcn?				: Si se debe dar por resuelta la devolución de la denuncia NO CONSIDERA EL RECHAZO
				trmn:	(objt['fechas_crr_rcpcn?'] and objt['chck_dvlcn?']),
			},
			'etp_invstgcn'   => {
				actv: ((objt['fechas_crr_rcpcn?'] or objt['on_dt?']) and objt['chck_dvlcn?']),
				# A esta etapa pasamos sin preguntarnos por la devolución, recien en este minuto se puede formalizar el pedido
#				actv: ((dnnc.rgstrs_ok? and dnnc.fechas_invstgcn?) or dnnc.on_dt?),
				trmn:	(dnnc.fecha_trmn? or dnnc.plz_invstgcn_vncd),
			},
			'etp_infrm'      => {
				actv: (dnnc.fecha_trmn? or dnnc.plz_invstgcn_vncd),
				trmn: (dnnc.fecha_env_infrm? or dnnc.fecha_rcpcn_infrm?),
			},
			'etp_prnncmnt'   => {
				actv: (dnnc.fecha_env_infrm? or dnnc.fecha_rcpcn_infrm?),
				trmn: (dnnc.fecha_prnncmnt? or dnnc.prnncmnt_vncd? or dnnc.fecha_rcpcn_infrm?),
			},
			'etp_mdds_sncns' => {
				actv: ( dnnc.fecha_prnncmnt? or dnnc.prnncmnt_vncd or dnnc.fecha_rcpcn_infrm? ),
				trmn: dnnc.fecha_cierre?,
			},
			'etp_cierre' => {
				actv: dnnc.fecha_cierre?,
				trmn: false,
			},
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