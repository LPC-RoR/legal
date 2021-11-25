class AppEnlace < ApplicationRecord

	TABLA_FIELDS = [
		['descripcion', 'link']
#		['enlace',      'link']
	]

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end

end
