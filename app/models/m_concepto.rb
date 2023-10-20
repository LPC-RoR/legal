class MConcepto < ApplicationRecord

#	TABLA_FIELDS = 	[
#		'm_concepto'
#	]
	
	belongs_to :m_modelo

	has_many :m_items

	def total(periodo_id)
		self.m_items.map {|item| item.total(periodo_id)}.sum
	end

	# ------------------------------------ ORDER LIST

	def owner
		self.m_modelo
	end

	def list
		self.m_modelo.m_conceptos.order(:orden)
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

	# -----------------------------------------------

	def presupuesto
		self.m_items.any? ? self.m_items.map {|item| item.presupuesto_seguro}.sum : 0
	end

	def total_periodo(periodo)
		self.m_items.map { |item| item.total_periodo(periodo) }.sum
	end

end
