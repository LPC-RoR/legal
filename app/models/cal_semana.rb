class CalSemana < ApplicationRecord
#	belongs_to :cal_mes

	has_many :cal_mes_sems
	has_many :cal_meses, through: :cal_mes_sems

	has_many :cal_dias
end
