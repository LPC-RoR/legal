class ReceptorDenuncia < ApplicationRecord
	has_many :krn_denuncias

	def self.dt
		find_by(receptor_denuncia: 'Dirección del Trabajo')
	end
end
