class AppEnlace < ApplicationRecord

	belongs_to :ownr, polymorphic: true

	scope :gnrl, -> { where(ownr_id: nil) }
	scope :dscrptn_ordr, -> { order(:descripcion) }

    validates_presence_of :descripcion, :enlace

end
