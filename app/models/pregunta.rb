class Pregunta < ApplicationRecord
	belongs_to :cuestionario

	has_many :respuestas


	# ------------------------------------ ORDER LIST

	def owner
		self.cuestionario
	end

	def list
		owner.preguntas.order(:orden)
	end

	def n_list
		self.list.count
	end

	def siguiente
		self.list.find_by(orden: self.orden + 1)
	end

	def anterior
		self.list.find_by(orden: self.orden - 1)
	end

	def redireccion
		"/pautas/#{self.id}"
	end

	# -----------------------------------------------
end
