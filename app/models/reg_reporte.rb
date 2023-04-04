class RegReporte < ApplicationRecord

	TABLA_FIELDS = [
		's#nombre_padre',
		'periodo',
		'estado'
	]

	has_many :registros

	def facturaciones
		TarFacturacion.where(owner_class: 'RegReporte', owner_id: self.id)
	end

	def owner
		self.owner_class.constantize.find(self.owner_id)
	end

	def nombre_padre
		"#{self.owner.class.name} : #{self.owner.send(self.owner.class.name.downcase)}"
	end

	def periodo
		"#{self.annio} | #{self.mes}"
	end

	def horas_reporte
		self.registros.map {|r| r.duracion - r.descuento}.sum / 3600
	end

	def tarifa_reporte
		self.owner.tar_tarifa.blank? ? 0 : (self.owner.tar_tarifa.valor_hora.blank? ? 0 : self.owner.tar_tarifa.valor_hora)
	end

	def moneda_reporte
		self.owner.tar_tarifa.blank? ? nil : (self.owner.tar_tarifa.moneda.blank? ? 'UF' : self.owner.tar_tarifa.moneda)
	end

	def monto_reporte
		self.tarifa_reporte.blank? ? 0 : self.horas_reporte * self.tarifa_reporte
	end

end
