class MPeriodo < ApplicationRecord

	has_many :m_registros

	def items
		items_ids = []
		self.m_modelo.m_conceptos.each do |concepto|
			items_ids = items_ids.union(concepto.m_items.ids)
		end
		MItem.where(id: items_ids)
	end
	
end
