class CalDia < ApplicationRecord
	belongs_to :cal_mes
	belongs_to :cal_semana

	def dyf?
		self.dia_semana == 'domingo' or CalFeriado.find_by(cal_fecha: self.dt_fecha).present?
	end
end
