class PdfArchivo < ApplicationRecord
	belongs_to :ownr, polymorphic: true

	scope :ordr, -> { order(:orden)}
end
