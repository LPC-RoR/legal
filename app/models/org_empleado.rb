class OrgEmpleado < ApplicationRecord

	belongs_to :org_cargo
	belongs_to :org_sucursal

	validates :rut, valida_rut: true
#    validates_presence_of :razon_social, :tipo_cliente

 	def d_rut
    	self.rut.gsub(' ', '').insert(-8, '.').insert(-5, '.').insert(-2, '-')
    end

	def padre_cliente
		self.org_cargo.org_area.padre_cliente
	end

	def empleado
		"#{self.nombres} #{self.apellido_paterno} #{self.apellido_materno}"
	end

	def enlaces
		AppEnlace.where(owner_class: self.class.name, owner_id: self.id)
	end

	def archivos
		AppArchivo.where(owner_class: self.class.name, owner_id: self.id)
	end

end
