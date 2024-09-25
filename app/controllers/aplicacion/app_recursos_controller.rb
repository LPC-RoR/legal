class Aplicacion::AppRecursosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
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

    # Nomina y perfil de Dog
    vrs = AppVersion.last
    nmn = AppNomina.find_by(email: AppVersion::DOG_EMAIL)
    AppNomina.create(nombre: AppVersion::DOG_NAME, email: AppVersion::DOG_EMAIL) if nmn.blank?
    prfl = AppPerfil.find_by(email: AppVersion::DOG_EMAIL)
    vrs.app_nomina = nmn
    nmn.app_perfil = prfl unless prfl.blank?

    # Nomina en general
    AppNomina.gnrl.each do |nmn|
      prfl = AppPerfil.find_by(email: nmn.email)
      nmn.app_perfil = prfl unless prfl.blank?
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
