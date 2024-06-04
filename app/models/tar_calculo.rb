class TarCalculo < ApplicationRecord
	belongs_to :tar_pago
	belongs_to :tar_aprobacion, optional: true

	has_many :tar_facturaciones

	# CHILDS

	def owner
		self.ownr_clss.constantize.find(self.ownr_id)
	end

	def cliente
		Cliente.find(self.cliente_id)
	end

	def monto_pesos
		self.monto
	end

	def cuantia_calculo
		self.cuantia
	end
end
