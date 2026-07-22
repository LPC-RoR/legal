class TarFacturacion < ApplicationRecord

	belongs_to :tar_factura, optional: true
	# DEPRECATED
	belongs_to :tar_aprobacion, optional: true
	belongs_to :tar_pago, optional: true
	belongs_to :tar_cuota, optional: true
	belongs_to :tar_calculo, optional: true

	belongs_to :ownr, polymorphic: true, optional: true

	belongs_to :cli_aprobacion, optional: true

	scope :sin_aprobar, -> { 
	  joins(:tar_calculo)
	    .where(tar_calculos: { tar_aprobacion_id: nil })
	    .where(cli_aprobacion_id: nil)
	    .where(facturado: [nil, false])
	}

	# Scope para obtener facturaciones de un cliente específico sin aprobar
	scope :sin_aprobar_de_cliente, ->(cliente_id) {
		causas_ids = Causa.where(cliente_id: cliente_id).pluck(:id)
		calculos_ids = TarCalculo.where(ownr_type: 'Causa', ownr_id: causas_ids).pluck(:id)

		sin_aprobar.where(tar_calculo_id: calculos_ids)
	}
	scope :no_facturado, -> { where(facturado: [nil, false]) }

	before_create :procesar_campos, if: -> { tipo_monto.present? }

	# DEPRECATED
	scope :no_aprbcn, -> { where(tar_aprobacion_id: nil) }
	scope :dspnbls, -> {where(tar_aprobacion_id: nil, tar_factura_id: nil)}

	delegate :cliente, to: :ownr, prefix: true

	# Dejamos el campo facturable por si lo necesitamos en los casos en los que tar_pago_id == nil

	# DEPRECATED: Es necesario para diferenciar el caso de las tarifas por hora. Se puede cambiar para que padre == ownr
	# ******************************************************************************** Manejo de Tarifas

	# /legal/app/controllers/organizacion/servicios_controller.rb:
	def origen_fecha_uf
		if self.ownr.class.name == 'Causa'
			tar_uf_facturacion = self.ownr.uf_facturaciones.find_by(tar_pago_id: self.tar_pago_id)
			tar_uf_facturacion.blank? ? 'TarFacturacion' : 'TarUfFacturacion'
		elsif self.ownr.class.name == 'Asesoria'
			self.ownr.fecha_uf.blank? ? 'TarFacturacion' : 'Asesoria'
		else
			'TarFacturacion'
		end
	end

	# -------------------------------------------------------------------------------------------------

	def uf_calculo
		fecha_uf.blank? ? nil : TarUfSistema.find_by(fecha: self.fecha_uf.to_date)
	end

	def monto_ingreso
		self.monto.blank? ? 0 : self.monto
	end

	def to_uf
		self.uf_calculo.blank? ? 0 : (self.monto_ingreso.to_d.truncate(0) / self.uf_calculo.valor)
	end

	def to_pesos
		self.uf_calculo.blank? ? 0 : (self.monto_ingreso * self.uf_calculo.valor)
	end	

	def monto_pesos
		self.moneda == 'Pesos' ? self.monto_ingreso : self.to_pesos
	end

	def monto_uf
		self.moneda == 'Pesos' ? self.to_uf : self.monto_ingreso
	end

	private

	def procesar_campos
	  return unless (tar_calculo.present? || ownr.present?) && tipo_monto.present?

	  if tar_calculo.present?
	    if tar_calculo.moneda == 'UF'
	      fecha_calculo = recalcular && fecha_uf ? fecha_uf : tar_calculo.fecha_uf
	      valor_uf = TarUfSistema.find_by(fecha: fecha_calculo)&.valor.to_f
	    end

	    ownr_objt = tar_calculo
	    total_calculo = case tipo_monto
	                    when 'Parcial'
	                      if monto_parcial.present?
	                        monto_parcial.to_f
	                      elsif porcentaje.present?
	                        ownr_objt.monto.to_f * (porcentaje.to_f / 100.0)
	                      else
	                        0.0
	                      end
	                    when 'Total'
	                      ownr_objt.monto.to_f
	                    else
	                      0.0
	                    end
	    moneda = ownr_objt.moneda
	  end

	  # --- Caso Ownr (Asesoria, Causa, etc.) ---
	  if ownr.present?
	    ownr_moneda = ownr.dsply_moneda
	    ownr_monto = ownr.dsply_monto.to_f

	    if ownr_moneda == 'UF'
	      fecha_calculo = fecha_uf.present? ? fecha_uf : Time.zone.today.to_date
	      uf = TarUfSistema.find_by(fecha: fecha_calculo)
	      valor_uf = uf&.valor.to_f

	      # Si sigue sin haber UF válida, usar 1.0 (sin conversión) o lanzar error
	      if valor_uf == 0
	        Rails.logger.error "❌ No se encontró UF válida para fecha #{fecha_calculo}"
	        valor_uf = 1.0
	      end
	    else
	      valor_uf = 1.0
	    end

	    total_calculo = case tipo_monto
	                    when 'Parcial'
	                      if monto_parcial.present?
	                        monto_parcial.to_f
	                      elsif porcentaje.present?
	                        ownr_monto.to_f * (porcentaje.to_f / 100.0)
	                      else
	                        0.0
	                      end
	                    when 'Total'
	                      ownr_monto.to_f
	                    else
	                      0.0
	                    end
	    ownr_objt = ownr
	    moneda = ownr_moneda || 'Pesos'
	  end


	  # --- Calcular monto acumulado de facturaciones previas ---
	  monto_fctrcns = if new_record?
	    ownr_objt.tar_facturaciones.where.not(id: nil).sum(:monto).to_f
	  else
	    ownr_objt.tar_facturaciones.where.not(id: self.id).sum(:monto).to_f
	  end

	  # --- Calcular monto final ---
	  monto_total = if moneda == 'UF'
	    total_calculo * valor_uf
	  else
	    total_calculo
	  end

	  self.monto = monto_total - monto_fctrcns
	end

	private

	def calculo_pago
		
	end
	
end
