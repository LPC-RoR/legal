class StEstado < ApplicationRecord

	TABLA_FIELDS = [
		'orden',
		'st_estado'
	]

	belongs_to :st_modelo

    validates_presence_of :orden, :estado, :destinos

  	def estado
		self.st_estado
	end
end
