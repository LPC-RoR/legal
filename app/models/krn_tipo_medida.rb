class KrnTipoMedida < ApplicationRecord

	ACCTN = 'tp_mdds'

	belongs_to :ownr, polymorphic: true
#	belongs_to :cliente, optional: true

	def self.ordr
		order(:tipo, :denunciante)
	end

end
