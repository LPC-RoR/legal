class RegReporte < ApplicationRecord

	TABLA_FIELDS = [
		's#nombre_padre',
		'periodo'
	]

	has_many :registros

	def owner
		self.owner_class.constantize.find(self.owner_id)
	end

	def nombre_padre
		"#{self.owner.class.name} : #{self.owner.send(self.owner.class.name.downcase)}"
	end

	def periodo
		"#{self.annio} | #{self.mes}"
	end

end
