class AppMejora < ApplicationRecord

	belongs_to :app_perfil

	TABLA_FIELDS = [
		'detalle'
	]

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end

end
