class Nota < ApplicationRecord

	belongs_to :ownr, polymorphic: true

	has_many :age_usu_notas
	has_many :age_usuarios, through: :age_usu_notas

	def perfil
		AppPerfil.find(self.perfil_id)
	end

	def color_text
		(self.realizado == true) ? 'muted' : (self.prioridad == 'Urgente' ? 'danger' : ( self.prioridad == 'Advertencia' ? 'warning' : 'info' ))
	end
	
	def color
		self.prioridad == 'Urgente' ? 'r' : ( self.prioridad == 'y' ? 'warning' : 'g' )
	end
end
