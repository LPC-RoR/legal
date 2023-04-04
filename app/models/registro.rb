class Registro < ApplicationRecord
	# Tabla de REGISTROS

	belongs_to :reg_reporte, optional: true

	TIPO_REGISTRO = ['Informe', 'Documento', 'Llamada telefónica', 'Mail', 'Reporte']

	TABLA_FIELDS = [
		'i#fecha',
		'tipo',
		's#detalle',
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

end
