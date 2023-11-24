class OrgSucursal < ApplicationRecord
	belongs_to :org_region

	has_many :org_empleados
end
