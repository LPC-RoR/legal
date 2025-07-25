class Aplicacion::AppRecursosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :inicia_sesion, only: [:procesos]

  include Tarifas

  helper_method :sort_column, :sort_direction

  def index
  end

  def ayuda
  end

  def usuarios
    set_tabla('usuarios', Usuario.all, true)
  end

  def procesos
  end

  def chck_estds
    Causa.all.each do |causa|
      if ['ingreso', 'pagada', 'tramitación'].include?(causa.estado)
        causa.estado = causa.get_estado
        causa.estado_pago = causa.get_estado_pago
        causa.save
      end
    end
    
    redirect_to root_path, notice: CausaArchivo.all.count
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
