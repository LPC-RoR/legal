class Hecho < ApplicationRecord

	belongs_to :tema, optional: true
	belongs_to :causa

	# se usa para manejar el formato enviado a clientes
	has_many :antecedentes

	has_many :hecho_archivos
	has_many :app_archivos, through: :hecho_archivos

	def color_c
		self.st_contestacion.blank? ? 'dark' : self.st_contestacion
	end

	def color_p
		self.st_preparatoria.blank? ? 'dark' : self.st_preparatoria
	end

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
