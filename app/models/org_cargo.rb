class OrgCargo < ApplicationRecord

	belongs_to :org_area

	has_many :org_empleados

	def padre_cliente
		self.org_area.padre_cliente
	end
end
