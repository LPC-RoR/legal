class DtMulta < ApplicationRecord
	belongs_to :dt_tramo
	belongs_to :dt_tabla_multa


	# ------------------------------------ ORDER LIST

	def owner
		self.dt_tabla_multa
	end

	def list
		owner.dt_multas.order(:orden)
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
		owner
	end

	# -----------------------------------------------

end
