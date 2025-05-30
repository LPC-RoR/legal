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

    Causa.all.each do |causa|
      if causa.age_actividades.adncs.any?

        adncs = causa.age_actividades.adncs.ftrs.fecha_ordr
        causa.fecha_audiencia = adncs.empty? ? nil : adncs.first.fecha
        causa.audiencia = adncs.empty? ? nil : adncs.first.age_actividad

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
