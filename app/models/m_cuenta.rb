class MCuenta < ApplicationRecord

	TABLA_FIELDS  = [
		's#m_cuenta',
		'm_formato:m_formato'
	]

	belongs_to :m_banco
	belongs_to :m_formato, optional: true
	belongs_to :m_modelo
	
	has_many :m_conciliaciones
end
