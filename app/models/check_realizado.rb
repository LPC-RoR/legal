class CheckRealizado < ApplicationRecord
  belongs_to :ownr, polymorphic: true

  validates :cdg, presence: true
  validates :rlzd, inclusion: { in: [true, false] }
  validates :chequed_at, presence: true

  # Evita duplicados a nivel de modelo
#  validates :cod, uniqueness: { scope: :ownr_type, :ownr_id }

	def self.objt_rlzd?(ownr, cdg)
	  CheckRealizado.exists?(ownr_type: ownr.class.name, ownr_id: ownr.id, cdg: cdg, rlzd: true)
	end
end
