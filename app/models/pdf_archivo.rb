class PdfArchivo < ApplicationRecord
	belongs_to :ownr, polymorphic: true

	has_many :pdf_registros
end
