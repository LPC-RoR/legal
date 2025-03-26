class CtrPaso < ApplicationRecord
	belongs_to :tarea

	has_many :ctr_registros
	has_many :hlp_ayudas, as: :ownr

	scope :ordr, -> { order(:orden) }

	include OrderModel

	# ------------------------------------ ORDER LIST

	def list
		self.tarea.ctr_pasos.ordr
	end

	def redireccion
		self.tarea.ctr_etapa.procedimiento
	end

	# -----------------------------------------------

end
