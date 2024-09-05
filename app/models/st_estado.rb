class StEstado < ApplicationRecord

	belongs_to :st_modelo

    validates_presence_of :orden, :estado

    scope :ordr, -> { order(:orden) }

    include OrderModel

  	def estado
		self.st_estado
	end

	# ------------------------------------ ORDER LIST

	def ownr
		self.st_modelo
	end

	def list
		self.ownr.st_estados.order(:orden)
	end

	def redireccion
		"/st_modelos/#{self.ownr.id}"
	end

	# -----------------------------------------------

end
