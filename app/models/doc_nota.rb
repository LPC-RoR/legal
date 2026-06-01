class DocNota < ApplicationRecord
	belongs_to :ownr, polymorphic: true
end
