class Audiencia < ApplicationRecord
	belongs_to :tipo_causa

	# ------------------------------------ ORDER LIST

	def owner
		self.tipo_causa
	end

	def list
		owner.audiencias.order(:orden)
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
		"/tipo_causas/#{self.owner.id}"
	end

	# -----------------------------------------------

end
