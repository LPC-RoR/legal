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

    Valor.delete_all

#    ControlDocumento.all.each do |cd|
#      cd.ownr_type = cd.owner_class
#      cd.ownr_id = cd.owner_id
#      cd.save
#    end

#    AppArchivo.all.each do |archv|
#      if archv.owner_class.blank? or archv.owner_id.blank?
        # Error! Borré los archivos (si existían) que se ingresan en hechos
#        archv.delete
#      else
#        archv.ownr_type = archv.owner_class
#        archv.ownr_id = archv.owner_id
#        archv.save
#      end
#    end

#    AppDocumento.all.each do |doc|
#        doc.ownr_type = doc.owner_class
#        doc.ownr_id = doc.owner_id
#        doc.save
#    end

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
