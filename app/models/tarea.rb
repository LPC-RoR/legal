class Tarea < ApplicationRecord
	belongs_to :ctr_etapa

	has_many :rep_doc_controlados, as: :ownr

	scope :ordr, -> {order(:orden)}

	include OrderModel

	def css_id
		"tar#{self.id}"
	end

	def owner
		self.ctr_etapa
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
		self.ownr.ctr_etapas.ordr
	end

	def redireccion
		self.owner.procedimiento
	end

	# -----------------------------------------------

	def list
		owner.tareas.ordr
	end

	def n_list
		self.list.count
	end

	def siguiente
		self.list.find_by(orden: self.orden + 1)
	end

	def anterior
		self.list.find_by(orden: self.orden - 1)
	end

	# -----------------------------------------------
end
