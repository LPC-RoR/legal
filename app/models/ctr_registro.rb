class CtrRegistro < ApplicationRecord
	belongs_to :ctr_paso
	belongs_to :tarea

	belongs_to :ownr, polymorphic: true

	scope :ordr, -> { order(:orden) }

end
