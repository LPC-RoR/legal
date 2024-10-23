module Plazos
	extend ActiveSupport::Concern

  	def plz_lv(fecha, dias)
  		unless fecha.blank? or dias.blank?
	  		frds = CalFeriado.where('cal_fecha BETWEEN ? AND ?', fecha.beginning_of_day, (fecha + dias.day).end_of_day)
	  		n_frds = frds.map {|frd| ['Saturday', 'Sunday'].exclude?(frd.cal_fecha.strftime('%A')) }.compact.count

	  		ds = dias + n_frds

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

	def plz_c(fecha, dias)
		( fecha.blank? or dias.blank? ) ? nil : fecha + dias.day
	end

end