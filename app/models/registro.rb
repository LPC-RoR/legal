class Registro < ApplicationRecord
	# Tabla de REGISTROS

	belongs_to :reg_reporte, optional: true

	TIPO_REGISTRO = ['Informe', 'Documento', 'Llamada telefónica', 'Mail', 'Reporte']

	TABLA_FIELDS = [
		'i#fecha',
		's#detalle',
		'abogado',
		'horas_minutos',
		'm#monto',
		'estado'
	]

    validates_presence_of :fecha, :abogado, :detalle

 	def padre
		if self.owner_class.blank?
			nil
		else
			self.owner_class.constantize.find(self.owner_id)
		end
	end

	def t_horas
		horas = self.horas.blank? ? 0 : self.horas
		minutos = self.minutos.blank? ? 0 : self.minutos
		horas += (minutos - (minutos % 60))/60
		horas
	end

	def t_minutos
		minutos = self.minutos.blank? ? 0 : self.minutos
		minutos % 60
	end

	def horas_minutos
		horas = self.horas.blank? ? 0 : self.horas
		minutos = self.minutos.blank? ? 0 : self.minutos
		horas += (minutos - (minutos % 60))/60
		minutos = minutos % 60
		"#{horas}:#{minutos}"
	end

	def factor
		t_horas.to_f + (t_minutos.to_f/60)
	end

	def moneda
		self.padre.present? ? (self.padre.tar_tarifa.present? ? (self.padre.tar_tarifa.moneda.present? ? self.padre.tar_tarifa.moneda : 'UF') : 'UF') : 'UF'
	end

	def monto
		self.padre.present? ? (self.padre.tar_tarifa.present? ? (self.padre.tar_tarifa.valor_hora.present? ? self.padre.tar_tarifa.valor_hora * self.factor : 0) : 0) : 0
	end

end
