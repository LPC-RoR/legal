class KrnLstModificacion < ApplicationRecord
  belongs_to :ownr, polymorphic: true

  scope :order, -> { order(:created_at) }

end
