class LglTramoEmpresa < ApplicationRecord

	# ------------------------------------ ORDER LIST

	def owner
		nil
	end

	def list
		LglTramoEmpresa.all.order(:orden)
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
		lgl_documentos_path
	end

	# -----------------------------------------------
end
