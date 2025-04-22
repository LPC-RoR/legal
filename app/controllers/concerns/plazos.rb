module Plazos
	extend ActiveSupport::Concern

	def plz_ok?(fecha, plazo)
		# noi si no hay plazo
		fecha_calculo = fecha.present? ? fecha.to_date : Time.zone.today.to_date
		plazo.present? ? plazo.to_date >= fecha_calculo.to_date : nil
	end

  	def plz_lv(fecha, dias)
  		unless fecha.blank? or dias.blank?
	  		frds = CalFeriado.where('cal_fecha BETWEEN ? AND ?', fecha.beginning_of_day, (fecha + dias.day).end_of_day)
	  		n_frds = frds.lv.count

	  		ds = dias + n_frds

	  		# Se consumen 5 por semanas => ds/5 = n_semanas
	  		s = (ds/5).to_i
	  		r = ds % 5
	  		skp = 4 - (fecha.to_date - fecha.monday.to_date).to_i
	  		r2 = r > skp ? r + 2 : r
	  		pls = s * 7 + r2

			fecha + pls.day
		else
			nil
		end
	end

	# Días hábiles para el plazo
	def lv_to_plz(fecha, plazo)
		fecha ||= Time.zone.today.to_date
		if plazo.blank?
			nil
		else
			n_dias = (plazo.to_date - fecha.to_date).to_i
	  		frds = CalFeriado.where('cal_fecha BETWEEN ? AND ?', fecha.beginning_of_day, plazo.end_of_day)
	  		n_frds = frds.lv.count
			n_dias == 0 ? 0 : n_dias - n_frds
		end
	end

	def plz_c(fecha, dias)
		( fecha.blank? or dias.blank? ) ? nil : fecha + dias.day
	end

	# dias corridos para el plazo
	def c_to_plz(fecha, plazo)
		fecha ||= Time.zone.today.to_date
		plazo.blank? ? nil : (plazo.to_date - fecha.to_date).to_i
	end

end