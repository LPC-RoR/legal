class DtTablaMulta < ApplicationRecord
	has_many :dt_multas
	has_many :dt_infracciones
end
