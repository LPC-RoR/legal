class TarHora < ApplicationRecord
	TABLA_FIELDS = [
		's#tar_hora',
		'valor_tarifa',
	]

	has_many :causas
	has_many :consultorias

	def valor_tarifa
		self.moneda == 'Pesos' ? "$ #{sprintf("%d", self.valor)}" : "UF #{self.valor}"
	end

	def padre
		self.owner_class.blank? ? nil : self.owner_class.constantize.find(self.owner_id)
	end
end
