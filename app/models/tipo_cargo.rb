class TipoCargo < ApplicationRecord
	has_many :cargos

    def self.typ(typ)
    	find_by(tipo_cargo: typ)
    end
end
