class TarComentario < ApplicationRecord

	belongs_to :tar_pago

	# ------------------------------------ ORDER LIST

	def owner
		self.tar_pago
	end

	def list
		self.owner.tar_comentarios.order(:orden)
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
		"/tar_pagos/#{self.owner.id}"
	end

	# -----------------------------------------------

end
