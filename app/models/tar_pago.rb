class TarPago < ApplicationRecord

	TABLA_FIELDS = [
		's#tar_pago',
#		'estado',
	]

	belongs_to :tar_tarifa

	has_many :tar_comentarios

    validates_presence_of :orden, :tar_pago

    def formula_tarifa
    	TarFormula.find_by(codigo: self.codigo_formula).tar_formula
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
