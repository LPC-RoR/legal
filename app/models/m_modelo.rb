class MModelo < ApplicationRecord

	has_many :m_conceptos
	has_many :m_bancos
	has_many :m_periodos

	def owner
		self.ownr_class.constantize.find(self.ownr_id)
	end

end
