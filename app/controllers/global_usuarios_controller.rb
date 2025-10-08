# usuarios globales
class GlobalUsuariosController < ApplicationController
  before_action :authenticate_usuario!   # <-- clave
  after_action  :verify_authorized

  def index
    @usuarios = Usuario.where(tenant_id: nil).order(:email)
#    authorize @usuarios, :index_global?, policy_class: UsuarioPolicy
    authorize Usuario, :index_global?, policy_class: UsuarioPolicy
  end

  def update
    @usuario = Usuario.find(params[:id])
    authorize @usuario, :update_role?, policy_class: UsuarioPolicy
    @usuario.update!(role: params[:usuario][:role])   # setter virtual
    redirect_to global_usuarios_path, notice: "Rol actualizado"
  end
end

