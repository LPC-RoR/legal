class MontoConciliacion < ApplicationRecord

	TIPOS = ['Autorizado', 'Ofrecido', 'Propuesta', 'Contrapropuesta', 'Acuerdo', 'Sentencia']

	belongs_to :causa
end
