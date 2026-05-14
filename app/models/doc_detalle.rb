class DocDetalle < ApplicationRecord
	belongs_to :ownr, polymorphic: true, optional: true
	belongs_to :doc_emitido
end
