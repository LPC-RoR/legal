class TarFechaCalculo < ApplicationRecord
	belongs_to :ownr, polymorphic: true
end
