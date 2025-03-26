class HlpAyuda < ApplicationRecord
	belongs_to :ownr, polymorphic: true
end
