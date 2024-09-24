class Demandante < ApplicationRecord
	belongs_to :causa

	has_many :tar_valor_cuantias

	def demandante
		"#{self.nombres} #{self.apellidos}"
	end
end