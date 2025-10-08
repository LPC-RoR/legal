# app/controllers/empresa_usuarios_controller.rb
class EmpresaUsuariosController < ApplicationController
  include Pundit::Authorization
  before_action :authenticate_usuario!
  before_action :set_empresa_and_tenant

  def index
    @usuarios = @tenant.usuarios.order(:email)
    authorize @usuarios, :index_tenant?, policy_class: UsuarioPolicy
  end

  def update_role
    @usuario = @tenant.usuarios.find(params[:usuario_id])
    authorize @usuario, :update_role?, policy_class: UsuarioPolicy

    nuevo_rol = params[:rol].to_sym
    unless Usuario::ROLES.include?(nuevo_rol)
      redirect_to "/cuentas/e_#{@empresa.id}/usrs", alert: "Rol no válido"
      return
    end

    # 1. Quitar roles previos SOBRE ESTE TENANT
    @usuario.roles.where(resource: @tenant).destroy_all

    # 2. Crear nuevo rol SOBRE ESTE TENANT
    Role.find_or_create_by!(name: nuevo_rol, resource: @tenant)
    @usuario.add_role(nuevo_rol, @tenant)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "usuario_#{@usuario.id}_rol",
          partial: 'empresas/usuario_rol',
          locals: { usuario: @usuario }
        )
      end
      format.html { redirect_to "/cuentas/e_#{@empresa.id}/usrs", notice: "Rol actualizado" }
    end
  end

  private

  def set_empresa_and_tenant
    @empresa = Empresa.find(params[:id])
    @tenant  = @empresa.tenant or raise ActiveRecord::RecordNotFound
  end
end