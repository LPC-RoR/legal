module CptnProcsHelper

	def etp_cntrl(ownr)
		clss = ownr.class.name
		dnnc = clss == 'KrnDenuncia' ? ownr : ( ['KrnDenunciante', 'KrnDenunciado'].include?(clss) ? ownr.krn_denuncia : ownr.ownr.krn_denuncia )
		{
			etp_rcpcn: true,
			etp_invstgcn: dnnc.dnnc_infrm_invstgcn_dt?,
			etp_crr_invstgcn: dnnc.dsply_cierre?
		}
	end

	def tar_cntrl(ownr)
		clss = ownr.class.name
		dnnc = clss == 'KrnDenuncia' ? ownr : ( ['KrnDenunciante', 'KrnDenunciado'].include?(clss) ? ownr.krn_denuncia : ownr.ownr.krn_denuncia )
		{
			dnnc_ingrs: true,
			dnncnt_diat_diep: dnnc.dnncnts?,
			dnnc_sgmnt: dnnc.dsply_sgmnt?,
			dnnc_drvcn: dnnc.dsply_drvcns?,
			dnnc_mdds: dnnc.prtcpnts?,
#			dnnc_mdds: dnnc.dsply_mdds?,
			dnnc_infrm_invstgcn_dt: dnnc.dsply_infrm_invstgcn_dt?,
			dnnc_invstgdr: dnnc.dnnc_infrm_invstgcn_dt?,
			dnnc_evlcn: dnnc.invstgdr?,
			dnnc_agndmnt: dnnc.eval?,
			dnnc_dclrcn: ownr.dsply_dclrcn?,
			dnnc_crr_dclrcns: dnnc.eval?,
			dnnc_infrm: dnnc.vlr_dnnc_crr_dclrcns?,
			dnnc_sncns: dnnc.vlr_dnnc_crr_dclrcns?,
			dnnc_infrm_dt: dnnc.sncns?
		}
	end

	def ownr_dnnc(ownr)
		ownr.class.name == 'KrnDenuncia' ? ownr : (['KrnDenunciante', 'KrnDenunciado'].include?(ownr.class.name) ? ownr.krn_denuncia : ownr.ownr.krn_denuncia)
	end

	def t_plz(ownr)
		denuncia = ownr_dnnc(ownr)
		{
			'dnnc_ingrs' => plz_lv(denuncia.fecha_legal, 1),             # Ingreso de la denuncia
			'dnncnt_diat_diep' => plz_lv(denuncia.fecha_legal, 1),		# Atención psicológica temprana
			'dnnc_mdds' => plz_lv(denuncia.fecha_legal, 1),				# Definición de medidas de protección y resguardo
			'dnnc_drvcn' => plz_lv(denuncia.fecha_legal, 1),				# Denunciante elige responsable de la investigación
			'dnnc_invstgdr' => plz_lv(denuncia.fecha_legal, 5),			# Plazo para asignar un investigador
			'dnnc_evlcn' => plz_lv(denuncia.fecha_legal, 7),				# Plazo para evaluar la denuncia
			'dnnc_agndmnt' => plz_lv(denuncia.fecha_legal, 10),			# Plazo para el agendamiento de declaraciones
			'dnnc_dclrcn' => plz_lv(denuncia.fecha_legal, 17),			# Plazo para la declaración denunciante(s)
			'dnnc_tstgs' => plz_lv(denuncia.fecha_legal, 25),			# Plazo para toda la gestión de testigos
			'dnnc_infrm' => plz_lv(denuncia.fecha_legal, 30),			# Plazo para terminar informe
			'dnnc_infrm_dt' => plz_lv(denuncia.fecha_legal, 32),			# Enviar informe a la DT
			'krn_infrmcn_dt' => plz_lv(denuncia.fecha_legal, 3),			# Información de la denuncia a la DT
		}
	end

	def e_plz(etp, ownr)
		denuncia = ownr_dnnc(ownr)
		etp.tareas.map {|tar| t_plz(denuncia)[tar.codigo]}.compact.max
	end

	def prfx_cntrllr(cdg)
		unless cdg.blank?
			case cdg.split('_')[0]
			when 'dnnc'
				'krn_denuncias'
			end
		else
			nil
		end
	end

	def actvbx_gly
		{
			'Derivación' => 'arrow-up-right',
			'Confirmación' => 'check2-square',
			'Selección' => 'check-square',
			'Recepción' => 'box-arrow-in-down-right',
			'Info' => 'toggle-on',
			'Fecha' => 'calendar2-check',
			'Radio' => 'ui-radios'
		}
	end

end
