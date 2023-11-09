class OrgArea < ApplicationRecord

	belongs_to :cliente, optional: true

	has_one  :parent_relation, :foreign_key => "child_id", :class_name => "OrgAreaArea"
	has_many :child_relations, :foreign_key => "parent_id", :class_name => "OrgAreaArea"

	has_one  :parent, :through => :parent_relation
	has_many :children, :through => :child_relations, :source => :child

	has_many :org_cargos

	def padre_cliente
		self.cliente_id.blank? ? self.parent.padre_cliente : self.cliente
	end

end
