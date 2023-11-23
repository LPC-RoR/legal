class MRegistro < ApplicationRecord

	CAMPOS = ['fecha', 'glosa_banco', 'documento', 'monto', 'cargo_abono', 'saldo']

	TABLA_FIELDS = [
		'$#monto',
		's#descripcion',
		'item',
		'fecha',
		'cargo_abono',
#		'saldo'
	]

	belongs_to :m_modelo
	belongs_to :m_conciliacion
	belongs_to :m_periodo, optional:true
	belongs_to :m_item, optional: true

	has_many :m_reg_facts
	has_many :tar_facturas, through: :m_reg_facts

	def periodo
		MPeriodo.find_by(clave: clave = self.fecha.year * 100 + self.fecha.month)
	end	

	def descripcion
		self.glosa.present? ? self.glosa : self.glosa_banco
	end

	def item
		self.m_item.blank? ? '-' : 'ok'
	end

	def disponible
		self.monto - (self.m_reg_facts.map {|rf| rf.monto}.sum)
	end

end
