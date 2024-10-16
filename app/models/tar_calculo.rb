class TarCalculo < ApplicationRecord
	belongs_to :tar_pago, optional: :true
	belongs_to :tar_aprobacion, optional: true

	belongs_to :ownr, polymorphic: true

	has_many :tar_facturaciones

	scope :no_aprbcn, -> { where(tar_aprobacion_id: nil) }

	delegate :cliente, to: :ownr, prefix: true

	# CHILDS

	def owner
		self.ownr_clss.constantize.find(self.ownr_id)
	end

	def monto_pesos
		self.monto
	end

	def cuantia_calculo
		self.cuantia
	end
end
