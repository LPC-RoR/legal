module DnncMthds
 	extend ActiveSupport::Concern

 	# ================================= Ingreso de datos

 	# TAREA 1 tsk_ingrs?
 	# Una denuncia debe tener al menos una persona denunciante y 
 	# (salvo que se trate de una denuncia de violencia, una persona denunciada)
	def prtcpnts_minimos?
		krn_denunciantes.exists? && (krn_denunciados.exists? || violencia?)
	end

 	# ================================= Entidad investigadora

 	# en el concern prtcpnts hay c{odigo que evita que un participante que no está marcado como externo tenga krn_empresa_externa_id}
	def emprss_ids
		(krn_denunciantes.pluck(:krn_empresa_externa_id) + krn_denunciados.pluck(:krn_empresa_externa_id)).uniq
	end

	def empleados_externos?
		krn_denunciantes.exists?(empleado_externo: true) || krn_denunciados.exists?(empleado_externo: true)
	end

	def externa?
		ids = emprss_ids
		empleados_externos? &&
		ids.size == 1 && ids[0] != nil
	end

	# Retorna elemento de ['Empresa', 'Empresa externa', 'Dirección del Trabajo']
	def ubccn_dnnc
		krn_derivaciones.none? ?  receptor_denuncia : krn_derivaciones.last&.destino
	end

	def on_empresa?
		ubccn_dnnc == KrnDenuncia::RECEPTORES[0]
	end

	def on_dt?
		ubccn_dnnc == KrnDenuncia::RECEPTORES[2]
	end

	def apt_coordinada?
		!!ownr.coordinacion_apt ? file_or_check?('crdncn_apt') : true
	end

	def vrfccn_solicitada?
		!!ownr.verificacion_datos ? file_or_check?('infrmcn') : true
	end

	def dnncnts_infrmds?
		krn_denunciantes.all? { |d| d.file_or_check?('dnncnt_info_oblgtr') }
	end

	def cmprbnts_enviados?
		krn_denunciantes.all? { |d| d.file_or_check?('comprobante') }
	end

	# Envío habilitado o artículo 516 del denunciantes y denunciados
	def envio_emails_prtcpnts_2?
	  krn_denunciantes.all?(&:envio_habilitado?) &&
	  krn_denunciados.all?(&:envio_habilitado?)
	end

	def dnnc_notificada?
		krn_denunciantes.all? { |d| d.file_or_check?('invstgcn') } &&
		krn_denunciados.all? { |d| d.file_or_check?('invstgcn') }
	end

	def dnnc_mdds_rsgrd?
		krn_denunciantes.all? { |d| d.file_or_check?('txt_mdds_rsgrd') } &&
		krn_denunciados.all? { |d| d.file_or_check?('txt_mdds_rsgrd') }
	end

	def apts?
		krn_denunciantes.all? { |d| d.file_or_check?('apt') }
	end

 	# Cierre de la recepción de la denuncia
 	# fecha_hora_dt		: Fecha y hora recepción derivación a la DT
 	# fecha_trmtcn 		: Fecha y hora informe de inicio de investigación
 	# fecha_ntfccn		: Fecha y hora notificación presentación denuncia en la DT
 	def cierre_rcpcn?
 		ubccn = ubccn_dnnc
 		( ubccn == KrnDenuncia::RECEPTORES[0] && !!fecha_trmtcn && !!investigacion_local ) ||
 		( ubccn == KrnDenuncia::RECEPTORES[1] && !!fecha_hora_dt && !!investigacion_externa ) ||
 		( ubccn == KrnDenuncia::RECEPTORES[2] && (!!fecha_hora_dt || rcp_dt?) )
 	end

 	# Se enfoca en el investigador y no en la presencia de registros en los participantes
 	def invstgdr_ok?
 		invstgdr = krn_inv_denuncias.where(objetado: [false, nil]).last
 		!!invstgdr && invstgdr.act_referencias&.any?
 	end

	def analisis_ok?
		!!evlcn_ok || (!!evlcn_incnsstnt && fecha_hora_corregida? && file_or_check?('denuncia_corregida'))
	end

	def tienen_dclrcn?
	  return false if krn_denunciantes.none?

	  # Solo chequea denunciados si violencia? es falso
	  if !violencia? && krn_denunciados.none?
	    return false
	  end

	  krn_denunciantes.all?(&:tiene_dclrcn?) &&
	  krn_denunciados.all?(&:tiene_dclrcn?) &&
	  krn_testigos.all?(&:tiene_dclrcn?)
	end

	def tiene_infrm?
		file_or_check?('txt_infrm')
	end

	def env_rcpcn_infrm?
 		ubccn_dnnc == KrnDenuncia::RECEPTORES[2] ? fecha_rcpcn_infrm? : fecha_env_infrm?
	end

	# ********************************************************************** PARTIALS

	def tiene_art4_1?
		krn_denunciantes.exists?(articulo_4_1: true) || krn_denunciados.exists?(articulo_4_1: true)
	end

	def tiene_mdds_sncns?
		file_or_check?('medidas_sanciones')
	end
	
	def fecha_ultima_evidencia
		act_archivos&.where(act_archivo: 'medidas_sanciones')&.last&.fecha
	end

	# ********************************************************************** DERIVACIÓN

	def drvcn_dt?
		krn_derivaciones.last&.destino == RECEPTORES[2]
	end

	# REVISAR MANEJO DE REGISTROS COMPLETOS
	# todos tienen rut e email, considera caso de articulo_516 y violencia
	def cmplts?
	  return false if krn_denunciantes.none?

	  # Solo chequea denunciados si violencia? es falso
	  if !violencia? && krn_denunciados.none?
	    return false
	  end

	  krn_denunciantes.all?(&:cmplt?) &&
	  krn_denunciados.all?(&:cmplt?) &&
	  krn_testigos.all?(&:cmplt?)
	end

end