class KrnLstModificacion < ApplicationRecord
  belongs_to :ownr, polymorphic: true

  scope :ordr, -> { order(:created_at) }

end
