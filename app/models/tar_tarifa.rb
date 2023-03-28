class TarTarifa < ApplicationRecord
	# Tabla de TARIFAS
	# tiene tar_detalles

	TABLA_FIELDS = [
		's#tarifa',
		'estado',
	]

	has_many :tar_pagos
	has_many :tar_formulas
	has_many :tar_detalles
	has_many :causas
	has_many :consultorias

    validates_presence_of :tarifa

	def padre
		self.owner_class.blank? ? nil : self.owner_class.constantize.find(self.owner_id)
	end
end
