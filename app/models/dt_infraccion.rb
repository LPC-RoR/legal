class DtInfraccion < ApplicationRecord
	belongs_to :dt_materia
	belongs_to :dt_tabla_multa

	has_many :dt_multas
end
