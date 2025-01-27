class TarTipoVariable < ApplicationRecord
	belongs_to :tar_tarifa
	belongs_to :tipo_causa
end
