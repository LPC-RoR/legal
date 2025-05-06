class PdfRegistro < ApplicationRecord
	belongs_to :ownr, polymorphic: true
	belongs_to :ref, polymorphic: true, optional: true
	belongs_to :pdf_archivo
end
