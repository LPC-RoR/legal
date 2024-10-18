class TarFacturacion < ApplicationRecord

	belongs_to :tar_factura, optional: true
	belongs_to :tar_aprobacion, optional: true
	belongs_to :tar_pago, optional: true
	belongs_to :tar_cuota, optional: true
	belongs_to :tar_calculo, optional: true

	belongs_to :ownr, polymorphic: true

	scope :no_aprbcn, -> { where(tar_aprobacion_id: nil) }
	scope :dspnbls, -> {where(tar_aprobacion_id: nil, tar_factura_id: nil)}

	delegate :cliente, to: :ownr, prefix: true

	# Dejamos el campo facturable por si lo necesitamos en los casos en los que tar_pago_id == nil

	# DEPRECATED: Es necesario para diferenciar el caso de las tarifas por hora. Se puede cambiar para que padre == ownr
#	def padre
#		self.owner_id.blank? ? nil : (self.owner_class == 'RegReporte' ? self.owner_class.constantize.find(self.owner_id).owner : self.owner_class.constantize.find(self.owner_id))
#	end
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
		ufs = TarUfSistema.find_by(fecha: self.fecha_uf.to_date)
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

end
