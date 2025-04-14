module ProcControl
  extend ActiveSupport::Concern

	# ------------------------------------------------------------------------------------- NEW VERSION

	def plz_ok?(fecha, plazo)
		fecha.present? ? plazo.to_date >= fecha.to_date : (plazo.to_date > Time.zone.today.to_date ? nil : false) unless plazo.blank?
	end

	def etp_cntrl_hsh(ownr)
		dnnc = ownr.dnnc
		fecha_legal = dnnc.fecha_dvlcn? ? dnnc.fecha_dvlcn : (dnnc.fecha_hora_dt? ? dnnc.fecha_hora_dt : dnnc.fecha_hora)
		fecha_env_rcpcn = dnnc.fecha_env_infrm || dnnc.fecha_rcpcn_infrm
		plz_env_rcpcn = dnnc.fecha_trmn? ? plz_lv(dnnc.fecha_trmn, 2) : plz_lv(fecha_legal, 32)
		{
			'etp_rcpcn'      => {
				actv: true,
				# rgstrs_ok?				: la información de los participantes ingresados hasta el momento está completa.
				# fechas_invstgcn?	: Tramitación, Certificado, Notificación, Devolución
				# chck_dvlcn?				: Si se debe dar por resuelta la devolución de la denuncia NO CONSIDERA EL RECHAZO
				trmn:	(dnnc.rgstrs_ok? and dnnc.fechas_invstgcn? and dnnc.chck_dvlcn?),
				plz: plz_lv(dnnc.fecha_hora, 3),
				plz_ok: dnnc.fecha_plz_rcpcn.present? ? plz_ok?( dnnc.fecha_plz_rcpcn, plz_lv(dnnc.fecha_hora, 3) ) : nil,
				plz_tag: lv_to_plz(dnnc.fecha_plz_rcpcn, plz_lv(dnnc.fecha_hora, 3))
			},
			'etp_invstgcn'   => {
				# A esta etapa pasamos sin preguntarnos por la devolución, recien en este minuto se puede formalizar el pedido
				actv: ((dnnc.rgstrs_ok? and dnnc.fechas_invstgcn?) or dnnc.on_dt?),
				trmn:	(dnnc.fecha_trmn? or dnnc.on_dt?),
				plz: plz_lv(fecha_legal, 30),
				plz_ok: plz_ok?( dnnc.fecha_trmn, plz_lv(fecha_legal, 30)),
				plz_tag: lv_to_plz(dnnc.fecha_trmn, plz_lv(fecha_legal, 30))
			},
			'etp_envio'      => {
				actv: ((dnnc.fecha_trmn? or dnnc.on_dt?)),
				trmn: (dnnc.fecha_env_infrm? or dnnc.fecha_rcpcn_infrm?),
				plz: plz_env_rcpcn,
				plz_ok: plz_ok?( fecha_env_rcpcn, plz_env_rcpcn),
				plz_tag: lv_to_plz(fecha_env_rcpcn, plz_env_rcpcn)
			},
			'etp_prnncmnt'   => {
				actv: (dnnc.fecha_env_infrm? or dnnc.on_dt?),
				trmn: (dnnc.fecha_prnncmnt? or dnnc.prnncmnt_vncd? or dnnc.on_dt?),
				plz: plz_lv(dnnc.fecha_env_infrm, 30),
				plz_ok: plz_ok?( dnnc.fecha_prnncmnt, plz_lv(dnnc.fecha_env_infrm, 30)),
				plz_tag: lv_to_plz(dnnc.fecha_prnncmnt, plz_lv(dnnc.fecha_env_infrm, 30))
			},
			'etp_mdds_sncns' => {
				actv: ( dnnc.fecha_prnncmnt? or dnnc.prnncmnt_vncd? or dnnc.fecha_rcpcn_infrm? ),
				trmn: dnnc.crr_dnnc,
				plz: plz_c((dnnc.fecha_prnncmnt || dnnc.fecha_rcpcn_infrm) , 15), 
				plz_ok: plz_ok?( dnnc.fl_last_date('dnnc_mdds_sncns'), plz_c((dnnc.fecha_prnncmnt || dnnc.fecha_rcpcn_infrm) , 15)),
				plz_tag: c_to_plz(dnnc.fl_last_date('dnnc_mdds_sncns'), plz_c((dnnc.fecha_prnncmnt || dnnc.fecha_rcpcn_infrm) , 15))
			},
		}
	end

	def tar_cntrl_hsh(ownr)
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
				frms: (ownr == dnnc),
			},
			'090_trmn_invstgcn' => {
				actv: ((dnnc.rlzds? and dnnc.evld?) or dnnc.on_dt?),
				frms: (dnnc.frms_trmn_invstgcn?),
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