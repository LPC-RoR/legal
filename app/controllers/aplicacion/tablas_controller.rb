class Aplicacion::TablasController < ApplicationController
  #before_action :set_tabla, only: %i[ show edit update destroy ]

  # GET /tablas or /tablas.json
  def index
    init_tab( { tablas: ['UF', 'Tarifas Generales', 'Tablas de Causas', 'Enlaces'] }, true )

    case @options[:tablas]
    when 'UF'
      init_tabla('tar_uf_sistemas', TarUfSistema.all.order(fecha: :desc), false)
    when 'Tarifas Generales'
      init_tabla('tar_tarifas', TarTarifa.where(owner_class: ''), false)
      add_tabla('tar_servicios', TarServicio.where(owner_class: ''), false)
    when 'Tablas de Causas'
      puts "ENTRO"
      init_tabla('tar_detalle_cuantias', TarDetalleCuantia.all.order(:tar_detalle_cuantia), false)
      add_tabla('tribunal_cortes', TribunalCorte.all.order(:tribunal_corte), false)
      add_tabla('tipo_causas', TipoCausa.all.order(:tipo_causa), false)
    when 'Enlaces'
      init_tabla('app_enlaces', AppEnlace.where(owner_id: nil).order(:descripcion), false)
      add_tabla('perfil-app_enlaces', AppEnlace.where(owner_class: 'AppPerfil', owner_id: perfil_activo.id).order(:descripcion), false)
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
end
