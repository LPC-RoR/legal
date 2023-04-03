class TarHora < ApplicationRecord
	TABLA_FIELDS = [
		'tar_hora',
		'm#valor',
	]

	has_many :causas
	has_many :consultorias

    validates_presence_of :tar_hora, :moneda, :valor

	def padre
		self.owner_class.blank? ? nil : self.owner_class.constantize.find(self.owner_id)
	end
end
