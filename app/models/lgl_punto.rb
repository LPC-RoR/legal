class LglPunto < ApplicationRecord
	belongs_to :lgl_parrafo

	# ------------------------------------ ORDER LIST

	def owner
		self.lgl_parrafo
	end

	def list
		self.owner.lgl_puntos.order(:orden, :created_at)
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
		"/lgl_documentos/#{self.lgl_parrafo.lgl_documento.id}/#oid#{self.lgl_parrafo.id}"
	end

	# -----------------------------------------------
end
