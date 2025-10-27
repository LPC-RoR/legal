class Menu < ApplicationRecord
	scope :enabled, -> { where(enabled: true) }
end
