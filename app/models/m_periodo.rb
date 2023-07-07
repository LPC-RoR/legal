class MPeriodo < ApplicationRecord

	TABLA_FIELDS  = [
		's#m_periodo'
	]

	belongs_to :m_modelo

	has_many :m_registros
	
end
