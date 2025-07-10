class CtrEtapa < ApplicationRecord
	belongs_to :procedimiento

	has_many :lgl_temas, as: :ownr

	scope :ordr, -> { order(:orden) }

	include OrderModel

	def ownr
		self.procedimiento
	end

	def lvl
		"#{self.ownr.orden}.#{self.orden}"
	end

	# ------------------------------------ ORDER LIST

	def list
		self.ownr.ctr_etapas.ordr
	end

	def redireccion
		self.ownr
	end

	# -----------------------------------------------
end