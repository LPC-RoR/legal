class ReceptorDenuncia < ApplicationRecord
	has_many :krn_denuncias

	def self.dt
		find_by(receptor_denuncia: 'Dirección del Trabajo')
	end

	def dt?
		self.receptor_denuncia == 'Dirección del Trabajo'
	end

	def empresa?
		self.receptor_denuncia == 'Empresa'
	end

	def externa?
		self.receptor_denuncia == 'Empresa externa'
	end
end
