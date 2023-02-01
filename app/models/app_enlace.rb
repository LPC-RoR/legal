class AppEnlace < ApplicationRecord

	TABLA_FIELDS = [
		'l#descripcion'
#		['enlace',      'link']
	]

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end

end
