class LglDato < ApplicationRecord
	belongs_to :lgl_parrafo

	# ------------------------------------ ORDER LIST

	def owner
		self.lgl_parrafo
	end

	def list
		self.owner.lgl_datos.order(:orden)
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
		"/tablas?tb=1"
	end

	# -----------------------------------------------
end
