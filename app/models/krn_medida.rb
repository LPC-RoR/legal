class KrnMedida < ApplicationRecord
	belongs_to :krn_lst_medida

	has_one :krn_modificacion

 	scope :ordr, -> { order(:created_at) }

 	def dscrpcn
 		self.krn_tipo_medida_id.blank? ? self.krn_medida : self.krn_tipo_medida.krn_tipo_medida
 	end

end
