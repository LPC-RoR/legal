module CptnCalendarioHelper

	def nombre_mes
		{
			1 => 'enero',
			2 => 'febrero',
			3 => 'marzo',
			4 => 'abril',
			5 => 'mayo',
			6 => 'junio',
			7 => 'julio',
			8 => 'agosto',
			9 => 'septiembre',
			10 => 'octubre',
			11 => 'noviembre',
			12 => 'diciembre'
		}
	end

	def month_key(year, month)
		"#{year} #{nombre_mes[month]}"
	end

	def clss_dia(fecha)
		if dyf(fecha)
			'd_dyf'
		elsif nombre_dia(fecha) == 'sábado'
			'd_s'
		else
			'd_h'
		end
	end

end