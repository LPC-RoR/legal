class Tarea < ApplicationRecord
	belongs_to :procedimiento

	# ------------------------------------ ORDER LIST

	def owner
		self.procedimiento
	end

	def list
		owner.tareas.order(:orden)
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
		"/tablas/general"
	end

	# -----------------------------------------------
end
