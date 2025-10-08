# app/controllers/concerns/set_current_tenant.rb
module SetCurrentTenant
  extend ActiveSupport::Concern

  included do
    before_action :set_current_tenant
  end

  private

  def set_current_tenant
    Tenant.current = current_usuario&.tenant
  end
end