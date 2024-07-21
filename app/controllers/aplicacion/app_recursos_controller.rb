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

    circular = LglDocumento.find(2)
    anexos = LglDocumento.create(lgl_documento: 'Anexos')
    prrs_circular = circular.lgl_parrafos.order(:orden)
    unless anexos.blank?
      prrs_circular.each do |prrf|
        if prrf.orden > 132
          if prrf.lgl_parrafo == '\n'
            prrf.delete
          else
            prrf.lgl_documento_id = anexos.id
            prrf.save
          end
        end
      end
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
