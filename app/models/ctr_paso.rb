class CtrPaso < ApplicationRecord
	belongs_to :tarea

	has_many :ctr_registros

	scope :ordr, -> { order(:orden) }
	scope :prcsbls, ->  { where(proceso: true) }
	scope :init, -> { where(proceso: [nil, false]) }

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
