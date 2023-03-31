class StModelo < ApplicationRecord
	TABLA_FIELDS = [
		's#st_modelo'
	]

	has_many :st_estados

    validates_presence_of :st_modelo

	def primer_estado
		self.st_estados.empty? ? nil : self.st_estados.order(:orden).first
	end

	def modelo
		self.st_modelo
	end

	def estados
		self.st_estados.order(:orden)
	end
end
