class Variable < ApplicationRecord

	TIPOS_VARIABLE = ['Texto', 'Párrafo', 'Número', 'Monto pesos', 'Monto UF']

	belongs_to :tipo_causa

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

	# -----------------------------------------------

	def valor_variable(causa)
		valor = causa.valores_datos.find_by(variable_id: self.id)
		campo = valor.c_string if self.tipo == 'Texto'
		campo = valor.c_text if self.tipo == 'Párrafo'
		campo = valor.c_numero if ['Número', 'Monto pesos', 'Monto UF'].include?(self.tipo)
		campo
	end
end
