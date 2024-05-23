class CausaArchivo < ApplicationRecord
	belongs_to :causa
	belongs_to :app_archivo

	def text_color
		[nil, 'nil'].include?(self.seleccionado) ? 'dark' : ( self.seleccionado == true ? 'info' : 'danger' )
	end

	# ------------------------------------ ORDER LIST

	def owner
		self.causa
	end

	def list
		owner.causa_archivos.order(:orden)
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
