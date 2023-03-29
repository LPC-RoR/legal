class StPerfilModelo < ApplicationRecord
	belongs_to :app_nomina

	has_many :st_perfil_estados

	def modelo
		self.st_perfil_modelo
	end

	def estados
		self.st_perfil_estados.order(:orden)
	end
end
