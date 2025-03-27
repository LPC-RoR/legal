class HlpNota < ApplicationRecord
	belongs_to :ownr, polymorphic: true

	scope :ordr, -> { order(:orden) }

	include OrderModel

	# ------------------------------------ ORDER LIST

	def list
		self.ownr.hlp_notas.ordr
	end

	def redireccion
		self.ownr
	end

	# -----------------------------------------------
end
