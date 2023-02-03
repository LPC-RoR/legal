class RegReporte < ApplicationRecord

	TABLA_FIELDS = [
		's#nombre_padre',
		'periodo',
		'estado'
	]

	has_many :registros

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
		self.owner.tar_hora.blank? ? 0 : self.owner.tar_hora.valor
	end

	def moneda_reporte
		self.owner.tar_hora.blank? ? nil : self.owner.tar_hora.moneda
	end

	def monto_reporte
		self.tarifa_reporte.blank? ? 0 : self.horas_reporte * self.tarifa_reporte
	end

end
