class DtInfraccion < ApplicationRecord
	belongs_to :dt_materia

	has_many :dt_multas
end
