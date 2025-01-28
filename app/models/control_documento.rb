class ControlDocumento < ApplicationRecord
	TIPOS = ['Documento', 'Archivo']
	CONTROLES = ['Requerido', 'Opcional']

	# ------------------------------------ ORDER LIST

	def owner
		self.owner_class.constantize.find(self.owner_id)
	end

	def list
		self.owner.control_documentos.order(:orden)
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
		case self.owner_class
		when 'TarDetalleCuantia'
			"/tablas?tb=7"
		when 'StModelo'
			"/st_modelos"
		end
	end

	# -----------------------------------------------
end
