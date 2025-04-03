class LglTema < ApplicationRecord
	belongs_to :ownr, polymorphic: true

	scope :ordr, -> { order(:orden) }

	include OrderModel

	# ------------------------------------ ORDER LIST

	def list
		self.ownr.lgl_temas.ordr
	end

	def redireccion
		self.ownr
	end

	# -----------------------------------------------
end
