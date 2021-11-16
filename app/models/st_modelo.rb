class StModelo < ApplicationRecord
	TABLA_FIELDS = [
		['st_modelo', 'show']
	]

	has_many :st_estados

	def primer_estado
		self.st_estados.empty? ? nil : self.st_estados.order(:orden).first
	end
end
