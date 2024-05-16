class Aplicacion::TablasController < ApplicationController

  def uf_regiones
      set_tabla('tar_uf_sistemas', TarUfSistema.all.order(fecha: :desc), false)
      set_tabla('regiones', Region.order(:orden), false)
  end

  def enlaces
      set_tabla('app_enlaces', AppEnlace.where(owner_id: nil).order(:descripcion), false)
      set_tabla('perfil-app_enlaces', AppEnlace.where(owner_class: 'AppPerfil', owner_id: perfil_activo.id).order(:descripcion), false)
  end

  def calendario
      # verifica calendarios activos
      verifica_annio_activo

      @primer_annio = CalAnnio.all.order(:cal_annio).first.cal_annio
      @ultimo_annio = CalAnnio.all.order(:cal_annio).last.cal_annio
      @annio_activo = params[:a].blank? ? CalAnnio.find_by(cal_annio: Time.zone.today.year) : CalAnnio.find_by(cal_annio: params[:a])

      set_tabla('cal_meses', @annio_activo.cal_meses.order(:cal_mes), false)
      set_tabla('cal_feriados', @annio_activo.cal_feriados.order(:cal_fecha), false)
  end

  def agenda
      set_tabla('age_usuarios', AgeUsuario.where(owner_class: '', owner_id: nil), true)
  end

  def tipos
      set_tabla('tipo_causas', TipoCausa.all.order(:tipo_causa), false)
      set_tabla('tipo_asesorias', TipoAsesoria.all.order(:tipo_asesoria), false)
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
