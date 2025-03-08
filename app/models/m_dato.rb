class MDato < ApplicationRecord

	belongs_to :m_formato

	def tag
		self.split_tag.blank? ? '-' : self.split_tag
	end

	def fila
		self.formula.blank? ? nil : self.formula.match(/([A-Z]+)([0-9]*)/)[2].to_i
	end
	
	def columna
		self.formula.blank? ? nil : self.formula.match(/([A-Z]+)([0-9]*)/)[1]
	end

 	# ------------------------------------ ORDER LIST

	def owner
		self.m_formato
	end

	def list
		self.m_formato.m_datos.order(:orden)
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
		"/m_formatos/#{self.owner.id}"
	end

	# -----------------------------------------------

end
