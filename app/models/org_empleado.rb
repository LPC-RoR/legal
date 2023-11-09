class OrgEmpleado < ApplicationRecord

	belongs_to :org_cargo

	def padre_cliente
		self.org_cargo.org_area.padre_cliente
	end

	def empleado
		"#{self.nombres} #{self.apellido_paterno} #{self.apellido_materno}"
	end
end
