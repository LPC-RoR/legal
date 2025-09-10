class CheckAuditoria < ApplicationRecord
  belongs_to :ownr, polymorphic: true

  validates :cdg, presence: true
  validates :prsnt, inclusion: { in: [true, false] }
  validates :audited_at, presence: true

  # Evita duplicados a nivel de modelo
#  validates :cod, uniqueness: { scope: :ownr_type, :ownr_id }

	# ¿Está este documento auditado como presente?
	def self.objt_audited?(ownr, cdg)
	  CheckAuditoria.exists?(ownr_type: ownr.class.name, ownr_id: ownr.id, cdg: cdg)
	end
	def self.objt_prsnt?(ownr, cdg)
	  CheckAuditoria.exists?(ownr_type: ownr.class.name, ownr_id: ownr.id, cdg: cdg, prsnt: true)
	end
end