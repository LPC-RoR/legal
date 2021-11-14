class HLink < ApplicationRecord

	TABLA_FIELDS = [
		['texto', 'show']
	]

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end
end
