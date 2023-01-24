class TarTarifa < ApplicationRecord
	# Tabla de TARIFAS
	# tiene tar_detalles

	TABLA_FIELDS = [
		['tarifa',   'show'],
		['estado',   'normal']
	]

	has_many :tar_detalles
	has_many :causas
	has_many :consultorias

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end
end
