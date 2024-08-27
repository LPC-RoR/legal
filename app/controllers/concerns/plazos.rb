module Plazos
	extend ActiveSupport::Concern

	# Entrega indice del día de dt_fecha en el arreglo
	def day_index(dt_fecha)
		['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].find_index(dt_fecha.strftime('%A'))
	end

	def nombre_dia(dt_fecha)
		['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'][day_index(dt_fecha)]
	end

	def no_lv(dt_fecha)
		['sábado', 'domingo'].include?(nombre_dia(dt_fecha)) or CalFeriado.where(cal_fecha: dt_fecha.beginning_of_day..dt_fecha.end_of_day).any?
	end

  	def plz_lv(fecha, dias)
		fch = fecha
		while no_lv(fch) do
			fch = fch + 1.day
		end
		ds = 0
		while ds < dias
			fch = fch + 1.day 
			unless no_lv(fch)
				ds += 1
			end
		end
		fch
	end

	def plz_c(fecha, dias)
		fecha + dias.day
	end

end