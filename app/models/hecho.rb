class Hecho < ApplicationRecord

	belongs_to :tema, optional: true
	belongs_to :causa

#	has_many :hecho_docs
#	has_many :app_documentos, through: :hecho_docs

	has_many :hecho_archivos
	has_many :app_archivos, through: :hecho_archivos

	# ------------------------------------ ORDER LIST

	def owner
		self.causa
	end

	def list
		owner.hechos.order(:orden)
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

	def redireccion
		"/causas/#{self.causa.id}?html_options[menu]=Hechos"
	end

	# -----------------------------------------------
end
