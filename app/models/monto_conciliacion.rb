class MontoConciliacion < ApplicationRecord

	TIPOS = ['Autorizado', 'Ofrecido', 'Propuesta', 'Contrapropuesta', 'Acuerdo', 'Sentencia']

	belongs_to :causa

	scope :ordr_fecha, -> { order(:created_at) }
end
