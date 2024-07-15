class HmParrafo < ApplicationRecord
	belongs_to :hm_pagina

	has_many :hm_links
	has_many :hm_notas

	require 'carrierwave/orm/activerecord'
	mount_uploader :imagen, IlustracionUploader

	# ------------------------------------ ORDER LIST

	def owner
		self.hm_pagina
	end

	def list
		self.owner.hm_parrafos.order(:orden)
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
		self.hm_pagina
	end

	# -----------------------------------------------
end
