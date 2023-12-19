class Hecho < ApplicationRecord

	belongs_to :tema

	has_many :hecho_docs
	has_many :app_documentos, through: :hecho_docs

	# ------------------------------------ ORDER LIST

	def owner
		self.tema
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
		"/causas/#{self.tema.causa.id}?html_options[menu]=Hechos"
	end

	# -----------------------------------------------
end
