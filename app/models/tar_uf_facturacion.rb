class TarUfFacturacion < ApplicationRecord

	belongs_to :tar_pago, optional: true
	belongs_to :ownr, polymorphic: true

	def owner
		self.owner_class.constantize.find(self.owner_id)
	end

end
