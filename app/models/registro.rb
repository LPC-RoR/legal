class Registro < ApplicationRecord
	# Tabla de REGISTROS

	TABLA_FIELDS = [
		['fecha',   'diahora'],
		['tipo',    'normal'],
		['detalle', 'show'],
		['estado',  'normal']
	]

	def padre
		if self.owner_class.blank?
			nil
		else
			self.owner_class.constantize.find(self.owner_id)
		end
	end
end
