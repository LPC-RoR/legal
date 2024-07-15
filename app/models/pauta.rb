class Pauta < ApplicationRecord
	has_many :cuestionarios


	# ------------------------------------ ORDER LIST

	def owner
		nil
	end

	def list
		Pauta.order(:orden)
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
		pautas_path
	end

	# -----------------------------------------------
end
