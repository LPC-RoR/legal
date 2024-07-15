class HmLink < ApplicationRecord
	belongs_to :hm_parrafo

	# ------------------------------------ ORDER LIST

	def owner
		self.hm_parrafo
	end

	def list
		self.owner.hm_links.order(:orden)
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
		self.hm_parrafo.hm_pagina
	end

	# -----------------------------------------------
end
