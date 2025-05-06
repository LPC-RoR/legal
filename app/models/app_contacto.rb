class AppContacto < ApplicationRecord
	belongs_to :ownr, polymorphic: true

	has_many :pdf_registros, as: :ownr
end
