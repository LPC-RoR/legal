class Valor < ApplicationRecord

	belongs_to :variable

	def owner
		self.owner_class.constantize.find(self.owner_id)
	end

	def valor
		['Número', 'Monto pesos', 'Monto UF'].include?(self.variable.tipo) ? valor.c_numero : ( self.variable.tipo == 'Texto' ? valor.c_string : ( self.variable.tipo == 'Parrafo' ? valor.c_text : nil ) )
	end
	
end
