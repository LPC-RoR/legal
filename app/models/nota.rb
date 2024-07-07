class Nota < ApplicationRecord

	has_many :age_usu_notas
	has_many :age_usuarios, through: :age_usu_notas

	def owner
		self.ownr_clss.constantize.find(self.ownr_id)
	end

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
