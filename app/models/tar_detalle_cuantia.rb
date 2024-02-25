class TarDetalleCuantia < ApplicationRecord

	has_many :tar_valor_cuantias
	has_many :tar_formula_cuantias

	has_many :tar_det_cuantia_controles
	has_many :control_documentos, through: :tar_det_cuantia_controles

    validates_presence_of :tar_detalle_cuantia
end