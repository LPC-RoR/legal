class TarDetalleCuantia < ApplicationRecord

	has_many :tar_valor_cuantias
	has_many :tar_formula_cuantias

    validates_presence_of :tar_detalle_cuantia
end