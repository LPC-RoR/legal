class KrnEmpleado < ApplicationRecord
	belongs_to :cliente

	has_many :krn_denunciantes
	has_many :krn_denunciados
end
