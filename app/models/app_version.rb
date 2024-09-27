class AppVersion < ApplicationRecord
	DOG_EMAIL = 'hugo.chinga.g@gmail.com'
	DOG_NAME = 'Hugo Chinga G.'

	has_one :app_nomina, as: :ownr

	has_many :cfg_valores

	def self.activa
		last		
	end

end
