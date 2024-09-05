class KrnModificacion < ApplicationRecord

	belongs_to :krn_lst_modificacion
	belongs_to :krn_medida, optional: true

 	scope :ordr, -> { order(:created_at) }

end
