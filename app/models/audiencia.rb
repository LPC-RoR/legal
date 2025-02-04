class Audiencia < ApplicationRecord
	belongs_to :tipo_causa

	include OrderModel

	# ------------------------------------ ORDER LIST

	def owner
		self.tipo_causa
	end

	def list
		owner.audiencias.order(:orden)
	end

	def redireccion
		"/tablas/tipos"
	end

	# -----------------------------------------------

end
