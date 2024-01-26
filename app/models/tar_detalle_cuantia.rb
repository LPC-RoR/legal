class TarDetalleCuantia < ApplicationRecord

	has_many :tar_valor_cuantias

    validates_presence_of :tar_detalle_cuantia

end
