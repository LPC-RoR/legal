class TarPago < ApplicationRecord

	TABLA_FIELDS = [
		'orden',
		's#tar_pago',
#		'estado',
	]

	belongs_to :tar_tarifa

	has_many :tar_comentarios

    validates_presence_of :orden, :tar_pago

    def formula_tarifa
    	TarFormula.find_by(codigo: self.codigo_formula).tar_formula
    end

end
