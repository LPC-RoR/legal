class CalMes < ApplicationRecord
	belongs_to :cal_annio

#	has_many :cal_semanas
	has_many :cal_mes_sems
	has_many :cal_semanas, through: :cal_mes_sems

	has_many :cal_dias
end
