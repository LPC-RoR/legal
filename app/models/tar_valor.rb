class TarValor < ApplicationRecord
	
	TABLA_FIELDS = [
		's#codigo',
		'd_detalle',
		'uf#valor_uf',
		'$#valor'
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
