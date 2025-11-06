class AgePendiente < ApplicationRecord
	belongs_to :age_usuario, optional: true
	belongs_to :usuario


	def text_color
		self.estado == 'realizado' ? 'muted' : 'dark'
	end

end
