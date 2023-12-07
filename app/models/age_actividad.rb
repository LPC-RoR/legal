class AgeActividad < ApplicationRecord

	def owner
		self.owner_class.constantize.find(self.owner_id)
	end
end
