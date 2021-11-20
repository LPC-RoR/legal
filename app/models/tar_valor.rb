class TarValor < ApplicationRecord
	
	TABLA_FIELDS = [
		['codigo',   'show'],
		['d_detalle',   'normal'],
		['valor_uf', 'uf'],
		['valor', 'pesos']
	]

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end

	def d_detalle
		(self.codigo.blank? or self.detalle.present?) ? self.detalle : self.padre.tar_tarifa.tar_detalles.find_by(codigo: self.codigo).detalle
	end

	def d_valor
		self.valor.blank? ? 0 : self.valor
	end

end
