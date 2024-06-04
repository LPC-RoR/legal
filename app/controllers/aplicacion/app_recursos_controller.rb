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

    TarFacturacion.where(owner_class: 'Causa').each do |fcn|
      # Puede ser una asesoría
      causa = fcn.owner
      pago = fcn.tar_pago
      unless causa.blank? or pago.blank?
        tar_uf_facturacion = get_tar_uf_facturacion(causa, pago)
        fcn.fecha_uf = tar_uf_facturacion.blank? ? fcn.created_at : tar_uf_facturacion.fecha_uf
        fcn.save
      end

      if fcn.tar_calculo_id.present?
        ccl = fcn.tar_calculo
        unless ccl.blank?
          ccl.fecha_uf = fcn.fecha_uf
          ccl.save
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
