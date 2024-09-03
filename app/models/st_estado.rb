class StEstado < ApplicationRecord

	TABLA_FIELDS = [
		'st_estado'
	]

	belongs_to :st_modelo

    validates_presence_of :orden, :estado

    scope :ordr_stts, -> { order(:orden) }

  	def estado
		self.st_estado
	end

	# ------------------------------------ ORDER LIST

	def owner
		self.st_modelo
	end

	def list
		self.owner.st_estados.order(:orden)
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
		"/st_modelos"
	end

	# -----------------------------------------------

end
