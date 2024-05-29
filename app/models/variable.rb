class Variable < ApplicationRecord

	TIPOS_VARIABLE = ['Texto', 'Párrafo', 'Número', 'Monto pesos', 'Monto UF']

	# DEPRECATED lo cambiamos a many to many
	#belongs_to :tipo_causa, optional: true
	#belongs_to :cliente, optional: true

	has_many :var_tp_causas
	has_many :tipo_causas, through: :var_tp_causas

	has_many :var_clis
	has_many :clientes, through: :var_clis

	has_many :valores

	def as_prms
		self.variable.split(' ').join('!')
	end

	def detalle
		self.descripcion.present? ? self.descripcion : self.variable
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
