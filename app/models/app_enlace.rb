class AppEnlace < ApplicationRecord

	TABLA_FIELDS = [
		'e#enlace'
	]

    validates_presence_of :descripcion, :enlace

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end

	def app_enlace
		self.descripcion
	end

end
