class Region < ApplicationRecord

	has_many :comunas
	has_many :org_regiones
	
	# ------------------------------------ ORDER LIST

	def owner
		nil
	end

	def list
		Region.all.order(:orden)
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
		"/tablas/uf_regiones"
	end

	# -----------------------------------------------
end
