module CptnProcsHelper

	def etp_cntrl
		{
			'etp_rcpcn' => true,
			'etp_invstgcn' => false,
			'etp_crr' => false
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
			'Selección' => 'toggles',
			'Recepción' => 'box-arrow-in-down-right',
			'Info' => 'toggle-on',
			'Fecha' => 'calendar2-check',
			'Radio' => 'ui-radios'
		}
	end

	def answ_accn(accn)
		case accn
		when 'Selección'
			'Info'
		else
			accn
		end		
	end

end
