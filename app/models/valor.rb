class Valor < ApplicationRecord

	belongs_to :variable

	def owner
		self.owner_class.constantize.find(self.owner_id)
	end
	
end
