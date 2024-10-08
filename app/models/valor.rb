class Valor < ApplicationRecord

	belongs_to :variable

	delegate :texto?, :parrafo?, :numero?, :booleano?, :pesos?, :uf?, to: :variable, prefix: true

	def valor
		if variable_numero?
			valor.c_numero
		elsif variable_texto?
			valor.c_string
		elsif variable_parrafo?
			valor.c_text
		elsif variable_booleano?
			valor.c_boleano
		end
	end
	
end
