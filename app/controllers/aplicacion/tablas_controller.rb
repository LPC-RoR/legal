class Aplicacion::TablasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on

  def tribunal_corte
    set_tabla('tribunal_cortes', TribunalCorte.trbnl_ordr, false)
  end

  def uf_regiones
      set_tabla('tar_uf_sistemas', TarUfSistema.all.order(fecha: :desc), false)
      set_tabla('regiones', Region.order(:orden), false)
  end

  def enlaces
      set_tabla('app_enlaces', AppEnlace.gnrl.dscrptn_ordr, false)
      set_tabla('perfil-app_enlaces', perfil_activo.app_enlaces.dscrptn_ordr, false)
  end

  def agenda
      @annio = params[:a].blank? ? Time.zone.today.year : params[:a].to_i

      @feriados = CalFeriado.where('extract(year  from cal_fecha) = ?', @annio).fecha_ordr

      set_tabla('cal_feriados', @feriados, false)
  end

  def tipos
      #proceso de tipos de causa con asociacion antigua
#      @vrbls = Variable.all.order(:variable)
#      @vrbls.each do |vrbl|
#        unless vrbl.tipo_causa_id.blank?
#          tipo_causa = TipoCausa.find(vrbl.tipo_causa_id)
#          unless tipo_causa.blank?
#            tipo_causa.variables << vrbl
#            if tipo_causa.variables.ids.include?(vrbl.id)
#              vrbl.tipo_causa_id = nil
#              vrbl.save
#            end
#          end
#        end 
#      end

      set_tabla('tipo_causas', TipoCausa.all.order(:tipo_causa), false)
      set_tabla('tipo_asesorias', TipoAsesoria.all.order(:tipo_asesoria), false)
      set_tabla('tipo_cargos', TipoCargo.all.order(:tipo_cargo), false)

  end

  def cuantias_tribunales
      set_tabla('tar_detalle_cuantias', TarDetalleCuantia.all.order(:tar_detalle_cuantia), false)
      set_tabla('tribunal_cortes', TribunalCorte.all.order(:tribunal_corte), false)
  end

  def tarifas_generales
      set_tabla('tar_tarifas', TarTarifa.where(owner_class: ''), false)
      set_tabla('tar_servicios', TarServicio.where(owner_class: ''), false)
  end

  def modelo
      if usuario_signed_in?
        # Repositorio de la plataforma
        general_sha1 = Digest::SHA1.hexdigest("Modelo de Negocios General")
        @modelo = MModelo.find_by(m_modelo: general_sha1)
        @modelo = MModelo.create(m_modelo: general_sha1) if @modelo.blank?

        set_tabla('m_cuentas', @modelo.m_cuentas.order(:m_cuenta), false)
      end
  end

  def periodos_bancos
      set_tabla('m_bancos', MBanco.all.order(:m_banco), false) 
      set_tabla('m_periodos', MPeriodo.order(clave: :desc), false) 
  end

  # GET /tablas or /tablas.json
  def index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
end
