# app/models/concerns/tenant_scoped.rb
module TenantScoped
  extend ActiveSupport::Concern

  included do
    belongs_to :tenant
    default_scope { where(tenant: Tenant.current) }
    validates :tenant, presence: true
  end
end