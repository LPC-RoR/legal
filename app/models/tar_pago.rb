class TarPago < ApplicationRecord

	belongs_to :tar_tarifa

	has_many :tar_comentarios
	has_many :tar_facturaciones
	has_many :tar_uf_facturaciones

	has_many :tar_calculos
	has_many :tar_cuotas

    validates_presence_of :orden, :tar_pago, :moneda

    def formula_tarifa
    	TarFormula.find_by(codigo: self.codigo_formula).tar_formula
    end

    def n_pagos
    	self.tar_cuotas.empty? ? 1 : self.tar_cuotas.count
    end

	# ------------------------------------ ORDER LIST

	def owner
		self.tar_tarifa
	end

	def list
		self.owner.tar_pagos.order(:orden)
	end

	def n_list
		self.list.count
	end

	def siguiente
		self.list.find_by(orden: self.orden + 1)
	end

	def anterior
		self.list.find_by(orden: self.orden - 1)
	end

	def redireccion
		"/tar_tarifas/#{self.owner.id}?html_options[menu]=Tarifas+y+servicios"
	end

	# -----------------------------------------------

end
