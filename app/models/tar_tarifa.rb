class TarTarifa < ApplicationRecord

	belongs_to :tipo_causa, optional: true
	belongs_to :ownr, polymorphic: true, optional: true

	has_many :tar_pagos
	has_many :tar_formulas
	has_many :causas

	has_many :tar_formula_cuantias
	has_many :tar_tipo_variables

    validates_presence_of :tarifa

	def n_pagos
		self.tar_pagos.map {|pago| pago.n_pagos}.sum
	end

	# Métodos para el cálculo de tarifas
end
