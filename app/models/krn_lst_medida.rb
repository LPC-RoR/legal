class KrnLstMedida < ApplicationRecord
  belongs_to :ownr, polymorphic: true

  has_many :krn_medidas

  scope :ordr, -> { order(:created_at) }

end
