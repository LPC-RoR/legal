module ProcControl
  extend ActiveSupport::Concern

	# ------------------------------------------------------------------------------------- NEW VERSION

	def etp_cntrl_hsh(ownr, objt)
		dnnc = ownr.dnnc
		{
			'etp_rcpcn'      => {
				actv: true,
				# rgstrs_ok?				: la información de los participantes ingresados hasta el momento está completa.
				# fechas_invstgcn?	: Tramitación, Certificado, Notificación, Devolución
				# chck_dvlcn?				: Si se debe dar por resuelta la devolución de la denuncia NO CONSIDERA EL RECHAZO
				trmn:	(dnnc.rgstrs_ok? and dnnc.fechas_invstgcn? and dnnc.chck_dvlcn?),
			},
			'etp_invstgcn'   => {
				# A esta etapa pasamos sin preguntarnos por la devolución, recien en este minuto se puede formalizar el pedido
				actv: ((dnnc.rgstrs_ok? and dnnc.fechas_invstgcn?) or dnnc.on_dt?),
				trmn:	(dnnc.fecha_trmn? or dnnc.on_dt?),
			},
			'etp_infrm'      => {
				actv: ((dnnc.fecha_trmn? or dnnc.on_dt?)),
				trmn: (dnnc.fecha_env_infrm? or dnnc.fecha_rcpcn_infrm?),
			},
			'etp_prnncmnt'   => {
				actv: (dnnc.fecha_env_infrm? or dnnc.on_dt?),
				trmn: (dnnc.fecha_prnncmnt? or dnnc.prnncmnt_vncd? or dnnc.on_dt?),
			},
			'etp_mdds_sncns' => {
				actv: ( dnnc.fecha_prnncmnt? or dnnc.prnncmnt_vncd? or dnnc.fecha_rcpcn_infrm? ),
				trmn: dnnc.fecha_cierre?,
			},
			'etp_cierre' => {
				actv: dnnc.fecha_cierre?,
				trmn: false,
			},
		}
	end

	def tar_cntrl_hsh(ownr, objt)
		dnnc = ownr.dnnc
		krn_dnnc = ownr != dnnc
		{
			'030_drvcns'    => {
				# La información de los participantes no necesita estas completa
				actv: (dnnc.denunciantes? and dnnc.denunciados?),
				frms: (dnnc.frms_drvcns?),
			},
			'050_crr'    => {
				# No exigimos dnnc.rgstrs_ok? para activar el cierre, 
				# pues al hacerlo nos quedamos en la tarea de derivación mostrando un mensaje que no tiene que ver con las derivaciones
				actv: (dnnc.investigacion_local or dnnc.investigacion_externa or dnnc.on_dt? or (dnnc.solicitud_denuncia and dnnc.on_empresa?)),
				frms: (dnnc.frms_crr?),
			},
			'060_invstgdr'    => {
				actv: (dnnc.rgstrs_ok? and dnnc.fechas_invstgcn?),
				frms: (not dnnc.frms_invstgdr?),
			},
			'070_evlcn'    => {
				actv: (dnnc.investigadores? and dnnc.objcn_ok?),
				frms: (dnnc.frms_evlcn?),
			},
			'080_dclrcn'    => {
				actv: (dnnc.investigadores? and dnnc.evld?),
				frms: true,
			},
			'090_trmn_invstgcn' => {
				actv: ((dnnc.dclrcns? and dnnc.evld?) or dnnc.on_dt?),
				frms: true,
			},
			'100_env_rcpcn' => {
				actv: (dnnc.fecha_trmn? or dnnc.on_dt?),
				frms: (dnnc.frms_env_rcpcn?),
			},
			'110_prnncmnt' => {
				actv: (dnnc.fecha_env_infrm? and (not dnnc.on_dt?)),
				frms: (dnnc.frms_prnncmnt?),
			},
			'120_mdds_sncns' => {
				actv: ( dnnc.fecha_prnncmnt? or dnnc.prnncmnt_vncd? or dnnc.fecha_rcpcn_infrm? ),
				frms: (dnnc.frms_mdds_sncns?),
			},
			'130_prcdmnt_crrd' => {
				actv: dnnc.fecha_cierre?,
				frms: false,
			},
		}
	end


	# ------------------------------------------------------------------------------------- PIS

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