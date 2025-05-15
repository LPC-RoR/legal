class CtrEtapa < ApplicationRecord
	belongs_to :procedimiento

	has_many :tareas
	has_many :lgl_temas, as: :ownr

	scope :ordr, -> { order(:orden) }

	include OrderModel

	def ownr
		self.procedimiento
	end

	def lvl
		"#{self.ownr.orden}.#{self.orden}"
	end

	def ok?
		tarea_ok?(self.tareas.ordr.last)
	end

	# Éste método sive para saber si la Etapa se despliega en KrnDenuncia, en KrnDenunciante, KrnDenunciado o KrnTestigo
	def dsply?(ownr)
		self.tareas.map {|tar| tar.dsply?(ownr)}.include?(true)
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