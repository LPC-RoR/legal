class TarCalculo < ApplicationRecord
	belongs_to :tar_pago

	has_many :tar_facturaciones

	# CHILDS

	def owner
		self.ownr_clss.constantize.find(self.ownr_id)
	end

	def cliente
		Cliente.find(self.cliente_id)
	end

end
