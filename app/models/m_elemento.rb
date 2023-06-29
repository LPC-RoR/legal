class MElemento < ApplicationRecord

	TABLA_FIELDS = [
		'm_elemento',
		'tipo'
	]
 
 	belongs_to :m_formato
	
	# ------------------------------------ ORDER LIST

	def owner
		self.m_formato
	end

	def list
		self.m_formato.m_elementos.order(:orden)
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
