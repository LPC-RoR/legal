class KrnTipoMedida < ApplicationRecord

	ACCTN = 'tp_mdds'

	belongs_to :ownr, polymorphic: true

	def self.ordr
		order(:tipo, :denunciante)
	end

    validates_presence_of :krn_tipo_medida

end
