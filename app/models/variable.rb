class Variable < ApplicationRecord

	TIPOS_VARIABLE = ['Texto', 'Párrafo', 'Número', 'Booleano', 'Monto pesos', 'Monto UF']

	include OrderModel

 	belongs_to :ownr, polymorphic: true

	has_many :valores

	scope :ordr, -> {order(:orden)}

	def as_prms
		self.variable.split(' ').join('!')
	end

	def detalle
		self.descripcion.present? ? self.descripcion : self.variable
	end

	# ----------------------------------------------- TIPOS

	def texto?
		self.tipo == TIPOS_VARIABLE[0]
	end

	def parrafo?
		self.tipo == TIPOS_VARIABLE[1]
	end

	def numero?
		[TIPOS_VARIABLE[2], TIPOS_VARIABLE[4], self.tipo == TIPOS_VARIABLE[5]].include?(self.tipo)
	end

	def booleano?
		self.tipo == TIPOS_VARIABLE[3]
	end

	def pesos?
		self.tipo == TIPOS_VARIABLE[4]
	end

	def uf?
		self.tipo == TIPOS_VARIABLE[5]
	end

	# ----------------------------------------------- ORDER LIST

	def list
		self.ownr.variables.ordr
	end

	def redireccion
		self.ctr_etapa.procedimiento
	end

	# DEPRECATED : Revisar nuevo uso de Variable:Valor
	# ----------------------------------------------- Causa -> Valor <- Variable

	def valor_campo(valor)
		['Número', 'Monto pesos', 'Monto UF'].include?(self.tipo) ? valor.c_numero : ( self.tipo == 'Texto' ? valor.c_string : ( self.tipo == 'Parrafo' ? valor.c_text : nil ) )
	end

	def valor_variable(causa)
		valor = self.valores.find_by(owner_class: 'Causa', owner_id: causa.id)
		valor.blank? ? nil : self.valor_campo(valor)
	end
end
