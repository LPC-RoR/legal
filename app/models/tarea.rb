class Tarea < ApplicationRecord
	belongs_to :ctr_etapa

	has_many :rep_doc_controlados, as: :ownr
	has_many :variables, as: :ownr

	scope :ordr, -> {order(:orden)}

	include OrderModel

	def css_id
		"tar#{self.id}"
	end

	def ok?
		tarea_ok?(self.codigo)
	end

	def lvl
		"#{self.owner.lvl}.#{self.orden}"
	end

	# Éste método sive para saber si la tarea se despliega en KrnDenuncia, en KrnDenunciante, KrnDenunciado o KrnTestigo
	def dsply?(ownr)
		if ownr.class.name == 'KrnDenuncia'
			self.sub_procs.present? ? self.sub_procs.split(',').include?(ownr.class.name) : true
		else
			self.sub_procs.present? ? self.sub_procs.split(',').include?(ownr.class.name) : false
		end
	end

	# ------------------------------------ ORDER LIST

	def list
		self.ctr_etapa.tareas.ordr
	end

	def redireccion
		self.ctr_etapa.procedimiento
	end

	# -----------------------------------------------

end
