class Aplicacion::TablasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on

  layout 'addt'

  def tribunal_corte
    set_pgnt_tbl('tribunal_cortes', TribunalCorte.trbnl_ordr)
  end

  def uf_regiones
    set_pgnt_tbl('tar_uf_sistemas', TarUfSistema.all.order(fecha: :desc))
#    @ufs      = TarUfSistema.all.order(fecha: :desc)
    @regiones = Region.order(:orden)
  end

  def enlaces
      set_tabla('app_enlaces', AppEnlace.gnrl.dscrptn_ordr, false)
      set_tabla('perfil-app_enlaces', perfil_activo.app_enlaces.dscrptn_ordr, false)
  end

  def agenda
      @annio = params[:a].blank? ? Time.zone.today.year : params[:a].to_i

      @feriados = CalFeriado.where('extract(year  from cal_fecha) = ?', @annio).fecha_ordr
  end

  def tipos
      set_tabla('tipo_causas', TipoCausa.all.order(:tipo_causa), false)
      set_tabla('tipo_asesorias', TipoAsesoria.all.order(:tipo_asesoria), false)
      set_tabla('tipo_cargos', TipoCargo.all.order(:tipo_cargo), false)
  end

  def cuantias_tribunales
      @cuantias = TarDetalleCuantia.all.order(:tar_detalle_cuantia)
  end

  def tarifas_generales
    @tar_causas     = TarTarifa.where(ownr_type: '')
    @tar_servicios  = TarServicio.where(ownr_type: '')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
end
