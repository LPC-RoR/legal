class StModelo < ApplicationRecord
	TABLA_FIELDS = [
		's#st_modelo'
	]

	has_many :st_estados

	def primer_estado
		self.st_estados.empty? ? nil : self.st_estados.order(:orden).first
	end
end
