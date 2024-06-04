class TarAprobacion < ApplicationRecord
	belongs_to :cliente
	
	has_many :tar_facturaciones
	has_many :tar_calculos

	def aprob_total_uf
		self.tar_facturaciones.map {|facturacion| facturacion.monto_uf}.sum
	end

	def aprob_total_pesos
		self.tar_facturaciones.map {|facturacion| facturacion.monto_pesos}.sum
	end

end
