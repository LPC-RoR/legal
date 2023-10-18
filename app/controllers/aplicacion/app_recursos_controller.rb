class Aplicacion::AppRecursosController < ApplicationController
  before_action :authenticate_usuario!, only: [:administracion, :procesos]
  before_action :inicia_sesion, only: [:administracion, :procesos, :home]

  include Sidebar
  include Tarifas

  helper_method :sort_column, :sort_direction

  def index
  end

  def ayuda
    carga_sidebar('Ayuda', params[:id])
  end

  def administracion
    carga_sidebar('Administración', params[:id])
  end

  def procesos
    MCuenta.all.each do |cuenta|
      cuenta.m_modelo_id = cuenta.m_banco.m_modelo_id
      cuenta.save
    end
    MRegistro.all.each do |registro|
      registro.m_modelo_id = registro.m_conciliacion.m_cuenta.m_banco.m_modelo_id
      registro.save
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
