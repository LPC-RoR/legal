# usuarios de un tenant
class TenantUsuariosController < ApplicationController
  before_action :set_tenant

  def index
    @usuarios = @tenant.usuarios.order(:email)
    authorize @usuarios, :index_tenant?, policy_class: UsuarioPolicy
  end

  def update
    @usuario = @tenant.usuarios.find(params[:id])
    authorize @usuario, :update_role?, policy_class: UsuarioPolicy
    @usuario.update!(role: params[:usuario][:role])
    redirect_to polymorphic_path([@tenant.owner, :tenant_usuarios])
  end

  private
  def set_tenant
    owner = (params[:empresa_id] ? Empresa : Cliente).find(params[:empresa_id] || params[:cliente_id])
    @tenant = owner.tenant or raise ActiveRecord::RecordNotFound
  end
end