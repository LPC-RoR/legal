class ActMetadata < ApplicationRecord
  belongs_to :act_archivo

  validates :act_metadata, presence: true, uniqueness: { scope: :act_archivo_id }
  validates :metadata, presence: true

  scope :cdgs, -> { where(act_metadata: 'cdgs') }
  scope :vlrs, -> { where(act_metadata: 'vlrs') }

  def self.codigo_existe?(archivo_id, codigo)
    exists?(act_archivo_id: archivo_id, act_metadata: codigo)
  end
end
