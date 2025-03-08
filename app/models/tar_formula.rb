class TarFormula < ApplicationRecord

	belongs_to :tar_tarifa

    validates_presence_of :orden, :tar_formula

	# ------------------------------------ ORDER LIST

	def owner
		self.tar_tarifa
	end

	def list
		self.owner.tar_formulas.order(:orden)
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
		"/tar_tarifas/#{self.owner.id}?html_options[menu]=Tarifas+y+servicios"
	end

	# -----------------------------------------------

end
