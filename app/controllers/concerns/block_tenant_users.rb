# app/controllers/concerns/block_tenant_users.rb
module BlockTenantUsers
  extend ActiveSupport::Concern

  included do
    before_action :redirect_if_user_has_tenant
  end

  private

  def redirect_if_user_has_tenant
    return unless current_usuario&.tenant_id.present? and (not current_usuario.dog?)

    redirect_to root_path, alert: 'La zona a la que intenta ingresar es solo para usuarios de la plataforma.'
  end
end