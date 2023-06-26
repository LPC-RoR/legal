class MBanco < ApplicationRecord

#	TABLA_FIELDS = 	[
#		'm_banco'
#	]
	
	belongs_to :m_modelo

	has_many :m_cuentas

end
