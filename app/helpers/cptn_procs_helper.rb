module CptnProcsHelper

	def etp_cntrl(ownr)
		clss = ownr.class.name
		dnnc = clss == 'KrnDenuncia' ? ownr : ( ['KrnDenunciante', 'KrnDenunciado'].include?(clss) ? ownr.krn_denuncia : ownr.ownr.krn_denuncia )
		{
			etp_rcpcn: true,
			etp_invstgcn: ((ownr.class.name == 'KrnDenuncia' and dnnc.fecha_trmtcn.present?) or controller_name != 'krn_denuncias'),
			etp_crr_invstgcn: (dnnc.dclrcn? or dnnc.sgmnt?)
		}
	end

	def tar_cntrl(ownr)
		clss = ownr.class.name
		dnnc = clss == 'KrnDenuncia' ? ownr : ( ['KrnDenunciante', 'KrnDenunciado'].include?(clss) ? ownr.krn_denuncia : ownr.ownr.krn_denuncia )
		{
			# Ingreso de datos básicos de la Denuncia
			dnnc_ingrs: true,							
			# Ingreso de participantes primarios: Sólo aparece si es necesario llenar empresa del empleado
			dnnc_prtcpnts: (ownr.class.name != 'KrnDenuncia' and ownr.empleado_externo),		
			# Si hay denunciantes, aparece uno para cada denunciante
			dnncnt_diat_diep: dnnc.dnncnts?,			
			# No es necesario que denunciados estén completos aún
			dnnc_mdds: dnnc.prtcpnts_ingrs?,
			# DEPRECATED
			dnnc_sgmnt: false,				
			# Registos de "principales" completo
			dnnc_drvcn: (dnnc.prtcpnts_ingrs? and (not dnnc.rcp_dt?)),				
			dnnc_infrm_invstgcn_dt: (dnnc.vlr_drv_emprs_optn? and dnnc.mdds? and dnnc.prtcpnts_ok?),
			dnnc_invstgdr: (dnnc.fecha_trmtcn.present?),
			dnnc_evlcn: dnnc.invstgdr?,
			dnnc_agndmnt: (dnnc.eval? and controller_name != 'krn_denuncias'),
			dnnc_dclrcn: (ownr.krn_declaraciones.any? and dnnc.dnnc_ok? and controller_name != 'krn_denuncias'),
			dnnc_crr_dclrcns: dnnc.dclrcn?,
			dnnc_infrm: (dnnc.vlr_dnnc_crr_dclrcns? or dnnc.sgmnt?),
			dnnc_sncns: (dnnc.vlr_dnnc_crr_dclrcns? or dnnc.sgmnt?),
			dnnc_infrm_dt: (dnnc.invstgcn_emprs? and dnnc.sncns?),
			dnnc_prnncmnt: dnnc.fecha_trmtcn.present?
		}
	end

	def dc_fl?(ownr, code)
		dc = RepDocControlado.find_by(codigo: code)
		dc.blank? ? false : ownr.rep_archivos.where(rep_doc_controlado_id: dc.id).present?
	end

	def ownr_dnnc(ownr)
		ownr.class.name == 'KrnDenuncia' ? ownr : (['KrnDenunciante', 'KrnDenunciado'].include?(ownr.class.name) ? ownr.krn_denuncia : ownr.ownr.krn_denuncia)
	end

	def t_plz(ownr)
		denuncia = ownr_dnnc(ownr)
		{
			'dnnc_ingrs' => plz_lv(denuncia.fecha_legal, 1),            # Ingreso de la denuncia
			'dnnc_prtcpnts' => plz_lv(denuncia.fecha_legal, 1),
			'dnncnt_diat_diep' => plz_lv(denuncia.fecha_legal, 1),		# Atención psicológica temprana
			'dnnc_drvcn' => plz_lv(denuncia.fecha_legal, 1),			# Denunciante elige responsable de la investigación
			'dnnc_mdds' => plz_lv(denuncia.fecha_legal, 1),				# Definición de medidas de protección y resguardo
			'dnnc_infrm_invstgcn_dt' => plz_lv(denuncia.fecha_legal, 3),
			'dnnc_invstgdr' => plz_lv(denuncia.fecha_legal, 5),			# Plazo para asignar un investigador
			'dnnc_evlcn' => plz_lv(denuncia.fecha_legal, 7),			# Plazo para evaluar la denuncia
			'dnnc_agndmnt' => plz_lv(denuncia.fecha_legal, 10),			# Plazo para el agendamiento de declaraciones
			'dnnc_dclrcn' => plz_lv(denuncia.fecha_legal, 17),			# Plazo para la declaración denunciante(s)
			'dnnc_tstgs' => plz_lv(denuncia.fecha_legal, 25),			# Plazo para toda la gestión de testigos
			'dnnc_crr_dclrcns' => plz_lv(denuncia.fecha_legal, 28),
			'dnnc_infrm' => plz_lv(denuncia.fecha_legal, 30),			# Plazo para terminar informe
			'dnnc_sncns' => plz_lv(denuncia.fecha_legal, 30),			# Plazo para terminar informe
			'dnnc_infrm_dt' => plz_lv(denuncia.fecha_legal, 32),			# Enviar informe a la DT
			'dnnc_prnncmnt' => plz_lv(denuncia.fecha_legal, 62),
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

	def rcptr_lst(formato)
		formato == 'P+' ? ['Empresa', 'Dirección del Trabajo', 'Empresa externa'] : ['Empresa', 'Dirección del Trabajo']
	end

end
