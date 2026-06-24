class TarFacturacion < ApplicationRecord

	belongs_to :tar_factura, optional: true
	# DEPRECATED
	belongs_to :tar_aprobacion, optional: true
	belongs_to :tar_pago, optional: true
	belongs_to :tar_cuota, optional: true
	belongs_to :tar_calculo, optional: true

	belongs_to :ownr, polymorphic: true

	belongs_to :cli_aprobacion, optional: true

	scope :sin_aprobar, -> { where(cli_aprobacion_id: nil) }

	# Scope para obtener facturaciones de un cliente específico sin aprobar
	scope :sin_aprobar_de_cliente, ->(cliente_id) {
		causas_ids = Causa.where(cliente_id: cliente_id).pluck(:id)
		calculos_ids = TarCalculo.where(ownr_type: 'Causa', ownr_id: causas_ids).pluck(:id)

		sin_aprobar.where(tar_calculo_id: calculos_ids)
	}

	before_save :procesar_campos

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
		# UF de recalcular
		if tar_calculo&.moneda == 'UF'
			fecha_calculo = recalcular && fecha_uf ? fecha_uf : tar_calculo.fecha_uf
			valor_uf = TarUfSistema.find_by(fecha: fecha_calculo)&.valor
			valor_uf ||= 0
		end
		case tipo_monto
		when 'Parcial'
			if monto_parcial.present?
				total_calculo = monto_parcial
			elsif porcentaje.present?
				total_calculo = tar_calculo.monto * (porcentaje / 100)
			else
				total_calculo = 0
			end
		when 'Total'
			total_calculo = tar_calculo.monto
		end

		monto_fctrcns 	= tar_calculo.tar_facturaciones.any? ? tar_calculo.tar_facturaciones.sum(:monto) : 0
		monto_total 	= tar_calculo&.moneda == 'UF' ? total_calculo * valor_uf : total_calculo
		self.monto 		= monto_total - monto_fctrcns
	end


end
