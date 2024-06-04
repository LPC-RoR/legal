class TarAprobacion < ApplicationRecord
	belongs_to :cliente
	
	has_many :tar_facturaciones
	has_many :tar_calculos

end
