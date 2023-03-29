class StPerfilEstado < ApplicationRecord

	belongs_to :st_perfil_modelo

	def estado
		self.st_perfil_estado
	end
end
