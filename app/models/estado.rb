class Estado < ApplicationRecord
	belongs_to :causa

	scope :ordr_dfecha, -> { order(created_at: :desc) }
end
