class TarTarifa < ApplicationRecord

	belongs_to :tipo_causa, optional: true

	has_many :tar_pagos
	has_many :tar_formulas
	has_many :tar_detalles
	has_many :causas
#	has_many :consultorias

	has_many :tar_formula_cuantias
	has_many :tar_tipo_variables

    validates_presence_of :tarifa

	def owner
		self.owner_class.blank? ? nil : self.owner_class.constantize.find(self.owner_id)
	end

	def n_pagos
		self.tar_pagos.map {|pago| pago.n_pagos}.sum
	end

	# Métodos para el cálculo de tarifas
end
