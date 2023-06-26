class MItem < ApplicationRecord
	belongs_to :m_concepto

	# ------------------------------------ ORDER LIST

	def owner
		self.m_concepto
	end

	def list
		self.m_concepto.m_items.order(:orden)
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
		'/m_modelos'
	end

	# -----------------------------------------------

end
