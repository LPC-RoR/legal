class Nota < ApplicationRecord

	belongs_to :ownr, polymorphic: true
	belongs_to :app_perfil

	has_many :age_usu_notas
	has_many :age_usuarios, through: :age_usu_notas

#	def perfil
#		AppPerfil.find(self.perfil_id)
#	end

end
