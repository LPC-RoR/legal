class OrgRegion < ApplicationRecord
	belongs_to :cliente
	belongs_to :region

	has_many :org_sucursales
end
