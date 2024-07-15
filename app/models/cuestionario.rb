class Cuestionario < ApplicationRecord
	belongs_to :pauta

	has_many :preguntas


	# ------------------------------------ ORDER LIST

	def owner
		self.pauta
	end

	def list
		owner.cuestionarios.order(:orden)
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
