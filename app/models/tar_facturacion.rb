class TarFacturacion < ApplicationRecord

	TABLA_FIELDS = [
		'glosa',
		'm#monto_ingreso',
		'$#monto_pesos'
	]

	belongs_to :tar_factura, optional: true
	belongs_to :tar_aprobacion, optional: true

	def padre
		self.owner_id.blank? ? nil : (self.owner_class == 'RegReporte' ? self.owner_class.constantize.find(self.owner_id).owner : self.owner_class.constantize.find(self.owner_id))
	end

	def owner
		self.owner_class.constantize.find(self.owner_id)
	end

	def tipo_owner
		case self.owner.class.name
		when 'TarServicio'
			'Servicio'
		when 'RegReporte'
			'Reporte Tareas'
		else
			self.owner.class.name
		end
	end

	def owner_description
		case self.owner.class.name
		when 'TarServicio'
			self.owner.descripcion
		when 'RegReporte'
			self.owner.reg_reporte
		when 'Asesoria'
			self.owner.descripcion
		else
			self.owner.send(self.owner.class.name.downcase)
		end
	end

	def pago
		if (['Causa', 'Consultoria'].include?(self.padre.class.name) and self.padre.tar_tarifa.tar_pagos.any?)
			self.padre.tar_tarifa.tar_pagos.find_by(codigo_formula: self.facturable)
		else
			nil
		end
	end

	def monto_ingreso
		self.monto.blank? ? 0 : self.monto
	end

	# métodos para la correcto uso de la UF
	# DEPRECATED
	def fecha_uf
		if self.tar_factura.blank? and self.tar_aprobacion.blank?
			if self.owner_class == 'Causa'
				pago = self.owner.tar_tarifa.tar_pagos.find_by(codigo_formula: self.facturable)
				uf_facturacion = self.owner.uf_facturaciones.find_by(pago: pago.tar_pago)
				uf_facturacion.blank? ? Time.zone.today.to_date : uf_facturacion.fecha_uf
			else
				Time.zone.today.to_date
			end
		else
			self.tar_factura.present? ? self.tar_factura.fecha : self.tar_aprobacion.fecha
		end
	end

	# esta fecha establece el día en el que se realizó el cálculo de la tarifa
	# verifica si hay fecha de cálculo en la causa, si no, es la fecha de creación del tar_facturacion
	def fecha_calculo
		if self.owner.class.name == 'Causa'
			pago = self.owner.tar_tarifa.tar_pagos.find_by(codigo_formula: self.facturable)
			uf_facturacion = self.owner.uf_facturaciones.find_by(pago: pago.tar_pago)
			uf_facturacion.blank? ? self.created_at : uf_facturacion.fecha_uf
		elsif self.owner.class.name == 'Asesoria'
			self.owner.fecha_uf.blank? ? self.created_at : self.owner.fecha_uf
		else
			self.created_at
		end
	end

	def uf_calculo
		TarUfSistema.find_by(fecha: self.fecha_calculo.to_date)
	end

	def to_pesos
		self.uf_calculo.blank? ? 0 : (self.monto_ingreso * self.uf_calculo.valor)
	end	

	def to_uf
		self.uf_calculo.blank? ? 0 : (self.monto_ingreso.to_d.truncate(0) / self.uf_calculo.valor)
	end

	def monto_pesos
		self.moneda == 'Pesos' ? self.monto_ingreso : self.to_pesos
	end

	def monto_uf
		self.moneda == 'Pesos' ? self.to_uf : self.monto_ingreso
	end

	def pago_tarifa
		if ['RegReporte', 'TarServicio'].include?(self.padre.class.name)
			nil
		else
			self.padre.tar_tarifa.tar_pagos.find_by(codigo_formula: self.facturable)
		end
	end

	def control_estado
		if self.tar_aprobacion.blank? and self.tar_factura.blank?
			'ingreso'
		elsif self.tar_aprobacion.present? and self.tar_factura.blank?
			'aprobación'
		elsif self.tar_factura.present?
			if self.tar_factura.documento.blank?
				'aprobado'
			elsif self.tar_factura.documento.present? and self.tar_factura.fecha_pago.blank?
				'facturado'
			elsif self.tar_factura.documento.present? and self.tar_factura.fecha_pago.present?
				'pagado'
			end
		end
	end

end
