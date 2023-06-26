class MCuenta < ApplicationRecord

	belongs_to :m_banco
	
	has_many :m_conciliaciones
end
