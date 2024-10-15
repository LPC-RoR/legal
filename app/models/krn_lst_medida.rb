class KrnLstMedida < ApplicationRecord
  belongs_to :ownr, polymorphic: true

  has_many :krn_medidas

  scope :ordr, -> { order(:created_at) }
  scope :mdds, -> { where(tipo: ['Principal', 'Extraordinaria']).ordr }
  scope :sncns, -> { where(tipo: 'Sancion').ordr}

  def flld?
    self.krn_medidas.any?
  end

end
