class CtrPaso < ApplicationRecord
	belongs_to :tarea

	has_many :ctr_registros

	scope :ordr, -> { order(:orden) }

	include OrderModel

	# ------------------------------------ ORDER LIST

	def list
		self.tarea.ctr_pasos.ordr
	end

	def redireccion
		self.tarea
	end

	# -----------------------------------------------

end
