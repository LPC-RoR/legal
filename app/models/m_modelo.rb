class MModelo < ApplicationRecord

	has_many :m_conceptos
	has_many :m_cuentas
	has_many :m_registros

	def owner
		self.ownr_class.constantize.find(self.ownr_id)
	end

end
