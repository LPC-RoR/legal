class AppVersion < ApplicationRecord

    has_one :tenant, as: :owner, dependent: :destroy

	has_one :app_nomina, as: :ownr
	has_many :rep_archivos, as: :ownr

	has_many :cfg_valores

	def self.activa
		last		
	end

end
