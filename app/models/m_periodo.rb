class MPeriodo < ApplicationRecord

	belongs_to :m_modelo

	has_many :m_registros
	
end
