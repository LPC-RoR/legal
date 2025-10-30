class TarTarifa < ApplicationRecord

	belongs_to :tipo_causa, optional: true
	belongs_to :ownr, polymorphic: true, optional: true

	has_many :tar_pagos
	has_many :tar_formulas
	has_many :causas

	# Contiene el porcentaje para el cálculo del variable y la fórmula de cálculo del valor tarifa
	has_many :tar_formula_cuantias

	# Contiene el porcentaje por defecto para el cálculo del variable. Uno por cada code_cuantia
	has_many :tar_tipo_variables

    validates_presence_of :tarifa

	def n_pagos
		self.tar_pagos.map {|pago| pago.n_pagos}.sum
	end

	# Métodos para el cálculo de tarifas

	def porcentaje_variable(code_causa, code_cuantia)
		defecto = tar_tipo_variables.find_by(code_causa: code_causa)&.variable_tipo_causa
		cuantia = tar_formula_cuantias.find_by(code_cuantia: code_cuantia)&.porcentaje_base
		cuantia.nil? ? defecto : cuantia
	end
end
