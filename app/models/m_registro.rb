class MRegistro < ApplicationRecord

	CAMPOS = ['fecha', 'glosa_banco', 'documento', 'monto', 'cargo_abono', 'saldo']

	TABLA_FIELDS = [
		'$#monto',
		'glosa_banco',
		'fecha',
		'documento',
		'cargo_abono',
		'saldo'
	]

	belongs_to :m_conciliacion
	belongs_to :m_periodo, optional:true
	
end
