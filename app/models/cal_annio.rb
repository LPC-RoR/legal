class CalAnnio < ApplicationRecord
	has_many :cal_meses
	has_many :cal_feriados
end
