class RcrsEnlace < ApplicationRecord
	belongs_to :ownr, polymorphic: true, optional:true

	scope :gnrl, -> { where(ownr_type: '', ownr_id: nil) }
	scope :dscrptn_ordr, -> { order(:descripcion) }

    validates_presence_of :descripcion, :link
end
