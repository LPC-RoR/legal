class Antecedente < ApplicationRecord
	belongs_to :causa
	belongs_to :hecho

	# ------------------------------------ ORDER LIST

	def owner
		self.causa
	end

	def list
		owner.antecedentes.order(:orden)
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
