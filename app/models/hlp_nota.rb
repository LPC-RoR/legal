class HlpNota < ApplicationRecord
	belongs_to :ownr, polymorphic: true

	# ------------------------------------ ORDER LIST

	def list
		self.ownr.hlp_notas.ordr
	end

	def redireccion
		self.ownr
	end

	# -----------------------------------------------
end
