class Nota < ApplicationRecord

	def owner
		self.ownr_clss.constantize.find(self.ownr_id)
	end

	def perfil
		AppPerfil.find(self.perfil_id)
	end

	def color_text
		self.prioridad == 'Urgente' ? 'danger' : ( self.prioridad == 'Advertencia' ? 'warning' : 'info' )
	end
	
	def color
		self.prioridad == 'Urgente' ? 'r' : ( self.prioridad == 'y' ? 'warning' : 'g' )
	end
end
