class MRegistro < ApplicationRecord

	CAMPOS = ['fecha', 'glosa_banco', 'documento', 'monto', 'cargo_abono', 'saldo']

	TABLA_FIELDS = [
		'$#monto',
		'descripcion',
		'fecha',
		'cargo_abono',
#		'saldo'
	]

	belongs_to :m_conciliacion
	belongs_to :m_periodo, optional:true
	belongs_to :m_item, optional: true

	def periodo
		MPeriodo.find_by(clave: clave = self.fecha.year * 100 + self.fecha.month)
	end	

	def descripcion
		self.glosa.present? ? self.glosa : self.glosa_banco
	end

end
