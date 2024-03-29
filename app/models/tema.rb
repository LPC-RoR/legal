class Tema < ApplicationRecord
	belongs_to :causa

	has_many :hechos

	# ------------------------------------ ORDER LIST

	def owner
		self.causa
	end

	def list
		owner.temas.order(:orden)
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
		"/causas/#{self.causa.id}?html_options[menu]=Hechos"
	end

	# -----------------------------------------------
end
