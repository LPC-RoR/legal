class StPerfilModelo < ApplicationRecord
	belongs_to :app_nomina

	has_many :st_perfil_estados

	def modelo
		self.st_perfil_modelo
	end

	def estados
		self.st_perfil_estados.order(:orden)
	end

	def estados_base
		StModelo.find_by(st_modelo: self.st_perfil_modelo).st_estados.map {|st_estado| st_estado.st_estado}
	end

	def estados_habilitados
		self.st_perfil_estados.map {|st_perfil_estado| st_perfil_estado.st_perfil_estado}
	end

	def st_estados_disponibles
		est =  self.estados_base - self.estados_habilitados
		StModelo.find_by(st_modelo: self.st_perfil_modelo).st_estados.where(st_estado: est)
	end
end
