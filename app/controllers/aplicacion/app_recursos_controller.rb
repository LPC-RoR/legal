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
    TarFacturacion.all.each do |tar_facturacion|
      tar_pago_ids = tar_facturacion.owner.class.name == 'Causa' ? tar_facturacion.owner.tar_tarifa.tar_pagos.ids: []
      unless tar_facturacion.tar_pago.blank?
        unless tar_pago_ids.include?(tar_facturacion.tar_pago.id)
          nuevo_tar_pago = tar_facturacion.owner.tar_tarifa.tar_pagos.find_by(tar_pago: tar_facturacion.tar_pago.tar_pago)
          unless nuevo_tar_pago.blank?
            tar_facturacion.tar_pago_id = nuevo_tar_pago.id
            tar_facturacion.save
          end
        end
      end
    end

    redirect_to root_path
  end

  def password_recovery
    @raw, hashed = Devise.token_generator.generate(Usuario, :reset_password_token)

    @user = Usuario.find(params[:uid])
    @user.reset_password_token = hashed
    @user.reset_password_sent_at = Time.now.utc
    @user.save    
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
