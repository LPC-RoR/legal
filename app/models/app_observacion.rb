class AppObservacion < ApplicationRecord

	belongs_to :app_perfil

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end

end
