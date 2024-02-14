class AgePendiente < ApplicationRecord
	belongs_to :age_usuario


	def text_color
		self.estado == 'realizado' ? 'muted' : self.prioridad
	end

end
