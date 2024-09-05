class KrnLstModificacion < ApplicationRecord
  belongs_to :ownr, polymorphic: true

  has_many :krn_modificaciones

  scope :ordr, -> { order(:created_at) }

end
