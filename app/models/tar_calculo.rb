class TarCalculo < ApplicationRecord
	belongs_to :tar_pago, optional: :true
	belongs_to :tar_aprobacion, optional: true

	belongs_to :ownr, polymorphic: true

	has_many :tar_facturaciones

	# Callbacks
	after_create :actualizar_estado_creacion
	after_destroy :actualizar_estado_eliminacion

	scope :no_aprbcn, -> { where(tar_aprobacion_id: nil) }

	delegate :cliente, to: :ownr, prefix: true

	# CHILDS

	def monto_pesos
		self.monto
	end

	def cuantia_calculo
		self.cuantia
	end

	private

	def actualizar_estado_creacion
	    return unless ownr.is_a?(Causa)
	    
	    ownr.with_lock do
	      if ownr.tar_calculos.count == 1 && ownr.may_up_to_con_cobros?
	        ownr.up_to_con_cobros!
	      end
	      if ownr.tar_calculos.count == ownr.tar_tarifa.tar_pagos.count && ownr.may_up_to_cobrada?
	        ownr.up_to_cobrada!
	      end
	    end
	end

	def actualizar_estado_eliminacion
	    return unless ownr.is_a?(Causa)
	    
	    ownr.with_lock do
	      # reload para asegurarnos de tener el conteo actualizado
	      if ownr.reload.tar_calculos.count == 0 && ownr.may_dwn_to_sin_cobros?
	        ownr.dwn_to_sin_cobros!
	      end
	      if ownr.reload.tar_calculos.count > 0 && ownr.may_dwn_to_con_cobros?
	        ownr.dwn_to_con_cobros!
	      end
	    end
	end

end
