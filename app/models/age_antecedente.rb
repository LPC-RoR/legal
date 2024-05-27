class AgeAntecedente < ApplicationRecord
	belongs_to :age_actividad

	def color
		self.tipo == 'Información' ? 'info' : ( self.tipo == 'Advertencia' ? 'warning' : 'danger' )
	end

	def gly
		self.tipo == 'Información' ? 'dot' : ( self.tipo == 'Advertencia' ? 'exclamation-lg' : 'cone-striped' )
	end

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
		"/causas/#{self.owner.owner.id}"
	end


end
