class Aplicacion::AppRecursosController < ApplicationController
  before_action :authenticate_usuario!, only: [:administracion, :procesos]
  before_action :inicia_sesion, only: [:administracion, :procesos, :home]

  include Tarifas

  helper_method :sort_column, :sort_direction

  def index
  end

  def ayuda
  end

  def usuarios
    set_tabla('usuarios', Usuario.all, true)
  end

  def administracion
  end

  def procesos
    Cliente.all.each do |cliente|
      if cliente.estado == 'ingreso'
        cliente.estado = 'activo'
        cliente.save
      end
    end

    Asesoria.all.each do |asesoria|
      asesoria.estado = asesoria.facturacion.blank? ? 'tramitacion' : (asesoria.facturacion.tar_factura.present? ? 'cerrada' : 'terminada' )
      asesoria.save
    end

    Causa.all.each do |causa|
      causa.estado = ['ingreso', 'proceso'].include?(causa.estado) ? 'tramitacion' : 'cerrada'
      causa.save
    end

    redirect_to root_path
  end

  def password_recovery
    if usuario_signed_in? or dog?
      @raw, hashed = Devise.token_generator.generate(Usuario, :reset_password_token)

      @user = Usuario.find(params[:uid])
      @user.reset_password_token = hashed
      @user.reset_password_sent_at = Time.now.utc
      @user.save
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def sort_column
      Publicacion.column_names.include?(params[:sort]) ? params[:sort] : "Author"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
