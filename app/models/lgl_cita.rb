class LglCita < ApplicationRecord
	belongs_to :lgl_parrafo

	scope :ordr, -> { order(:orden) }

	include OrderModel

	# ------------------------------------ ORDER LIST

	def list
	self.lgl_parrafo.lgl_citas.ordr
	end

	def redireccion
		self.lgl_parrafo
	end

	# -----------------------------------------------
end
