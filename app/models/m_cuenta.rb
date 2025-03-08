class MCuenta < ApplicationRecord

	belongs_to :m_banco
	belongs_to :m_formato, optional: true
	belongs_to :m_modelo
	
	has_many :m_conciliaciones
end
