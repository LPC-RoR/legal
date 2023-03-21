class Aplicacion::AppRecursosController < ApplicationController
  before_action :authenticate_usuario!, only: [:administracion, :procesos, :bandeja]
  before_action :inicia_sesion, only: [:administracion, :procesos, :home]

  include Sidebar

  helper_method :sort_column, :sort_direction

  def index
    #utilizado para actualizar recuersos en general
    init_tab( { enlaces: ['Público', 'Perfil'] }, true )

    @coleccion = {}
    @coleccion['app_enlaces'] = AppEnlace.where(owner_id: nil).order(:descripcion) if @options[:enlaces] == 'Público'
    @coleccion['app_enlaces'] = AppEnlace.where(owner_class: 'AppPerfil', owner_id: perfil_activo.id).order(:descripcion) if @options[:enlaces] == 'Perfil'
    @coleccion['tar_uf_sistemas'] = TarUfSistema.all.order(fecha: :desc)

  end

  def home
    @coleccion = {}
    @coleccion['clientes'] = Cliente.where(id: TarFacturacion.where(estado: 'ingreso').map {|tarf| tarf.padre.cliente.id unless tarf.tar_factura.present?}.compact.uniq)
  end

  def ayuda
    carga_sidebar('Ayuda', params[:id])
  end

  def administracion
    carga_sidebar('Administración', params[:id])
  end

  def procesos
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
