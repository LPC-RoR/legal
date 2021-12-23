class TarVariable < ApplicationRecord

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end

end
