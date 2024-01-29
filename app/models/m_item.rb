class MItem < ApplicationRecord
	belongs_to :m_concepto

	has_many :m_registros

	def total(periodo_id)
		self.m_registros.where(m_periodo_id: periodo_id).map {|r| r.monto}.sum
	end

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
		"/tablas?tb=8"
	end

	# -----------------------------------------------

	def presupuesto_seguro
		self.presupuesto.blank? ? 0 : self.presupuesto
	end

	def total_periodo(periodo)
		periodo.m_registros.where(m_item_id: self.id).map {|reg| reg.monto}.sum
	end

end
