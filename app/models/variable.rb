class Variable < ApplicationRecord

	TIPOS_VARIABLE = ['Texto', 'Párrafo', 'Número', 'Monto pesos', 'Monto UF']

	belongs_to :tipo_causa

	has_many :valores

	# ------------------------------------ ORDER LIST

	def owner
		self.tipo_causa
	end

	def list
		owner.variables.order(:orden)
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
		"/tipo_causas/#{self.owner.id}"
	end

	# ----------------------------------------------- Causa -> Valor <- Variable

	def valor_campo(valor)
		['Número', 'Monto pesos', 'Monto UF'].include?(self.tipo) ? valor.c_numero : ( self.tipo == 'Texto' ? valor.c_string : ( self.tipo == 'Parrafo' ? valor.c_text : nil ) )
	end

	def valor_variable(causa)
		valor = self.valores.find_by(owner_class: 'Causa', owner_id: causa.id)
		valor.blank? ? nil : self.valor_campo(valor)
	end
end
