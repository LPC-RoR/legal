class AppEnlace < ApplicationRecord

	TABLA_FIELDS = [
		'e#enlace'
#		['enlace',      'link']
	]

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end

	def app_enlace
		self.descripcion
	end

end
