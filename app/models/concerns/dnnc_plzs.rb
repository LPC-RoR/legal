module DnncPlzs
 	extend ActiveSupport::Concern

 	# ================================= KrnPrcdmnt

 	def plz_fecha_inicio(etapa)
 		case etapa
 		when :etp_rcpcn
 			fecha_hora
 		when :etp_invstgcn
 			# 1.- En caso de 'devolución' esta fecha prima por sobre todas las anteriores
 			# 2.- Si la denuncia fue derivada a la DT, se usa la fecha del certificado
 			# 3.- Se usa la evcha de recepción
 			fecha_dvlcn? ? fecha_dvlcn : (fecha_hora_dt? ? fecha_hora_dt : fecha_hora)
 		when :etp_infrm
 			# ¿Es necesario fijar un hito 'término de la investigación' por ahora no lo tenemos
 			# Mientras asumimos que el plazo es SIEMPRE dos hábiles despues de 30
 			base = fecha_dvlcn? ? fecha_dvlcn : (fecha_hora_dt? ? fecha_hora_dt : fecha_hora)
 			::CalFeriado.plazo_habil(base, 30)
 		when :etp_prnncmnt
 			# No aplica a las investigaciones investigadas por la DT
 			# Si aplica, se calcula a partir de la fecha en la cual se envió el informe a la DT
 			unless on_dt?
 				fecha_env_infrm
 			end
 		when :etp_mdds_sncns
 			# 1.- Investigada en la DT: fecha de recepción del informe
 			# 2.- Plazo para el pronunciamiento vencido: 30 hábiles desde la fecha de envío
 			# 3.- Fecha del pronunciamiento
 			on_dt? ? fecha_rcpcn_infrm : (prnncmnt_vncd ? ::CalFeriado.plazo_habil(fecha_env_infrm, 30) : fecha_prnncmnt)
 		end
 	end

 	def plz_fecha_cmplmnt(etapa)
 		case etapa
 		when :etp_rcpcn
 			rcp_dt? ? nil : (on_dt? ? krn_derivaciones.last.fecha.to_date : fecha_trmtcn)
 		when :etp_invstgcn
 			on_dt? ? nil : dnnc.fecha_trmn
 		when :etp_infrm
 			on_dt? ? fecha_rcpcn_infrm : fecha_env_infrm
 		when :etp_prnncmnt
 			on_dt? ? nil : dnnc.fecha_prnncmnt
 		when :etp_mdds_sncns
 			fecha_cierre
 		end
 	end

 	def plazo(etapa)
 		case etapa
 		when :etp_rcpcn
 			CalFeriado.plazo_habil(plz_fecha_inicio(:etp_rcpcn), 3)
 		when :etp_invstgcn
 			CalFeriado.plazo_habil(plz_fecha_inicio(:etp_invstgcn), 30)
 		when :etp_infrm
 			CalFeriado.plazo_habil(plz_fecha_inicio(:etp_infrm), 2)
 		when :etp_prnncmnt
 			CalFeriado.plazo_habil(plz_fecha_inicio(:etp_prnncmnt), 30)
 		when :etp_mdds_sncns
 			CalFeriado.plazo_corrido(plz_fecha_inicio(:etp_mdds_sncns), 15)
 		end
 	end

end