class TarFormulaCuantia < ApplicationRecord

	belongs_to :tar_tarifa
	belongs_to :tar_detalle_cuantia
end
