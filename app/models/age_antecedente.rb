class AgeAntecedente < ApplicationRecord
	belongs_to :age_actividad

	# ------------------------------------ ORDER LIST

	def owner
		self.age_actividad
	end

	def list
		self.age_actividad.age_antecedentes.order(:orden)
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
		"/tablas?tb=5"
	end


end
