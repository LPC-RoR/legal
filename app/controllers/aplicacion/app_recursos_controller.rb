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
    TarFacturacion.all.each do |pago|
      if pago.owner.present? and pago.owner.class.name == 'Causa'
        tar_pago = pago.owner.tar_tarifa.tar_pagos.find_by(codigo_formula: pago.facturable)
        unless tar_pago.blank?
          pago.tar_pago_id = tar_pago.id 
          pago.save
        end
      end
    end

    TarUfFacturacion.all.each do |uf_pago|
      if uf_pago.owner.present? and uf_pago.owner.class.name == 'Causa'
        tar_pago = uf_pago.owner.tar_tarifa.tar_pagos.find_by(tar_pago: uf_pago.pago)
        unless tar_pago.blank?
          uf_pago.tar_pago_id = tar_pago.id 
          uf_pago.save
        end
      end
    end

    redirect_to root_path
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
