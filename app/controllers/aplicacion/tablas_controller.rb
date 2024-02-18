class Aplicacion::TablasController < ApplicationController

  # GET /tablas or /tablas.json
  def index

    @indice = params[:tb].blank? ? first_tabla_index : params[:tb].to_i

    case tb_item(@indice)
    when 'UF & Regiones' #UF & Regiones
      set_tabla('tar_uf_sistemas', TarUfSistema.all.order(fecha: :desc), false)
      set_tabla('regiones', Region.order(:orden), false)
    when 'Enlaces' #Enlaces
      set_tabla('app_enlaces', AppEnlace.where(owner_id: nil).order(:descripcion), false)
      set_tabla('perfil-app_enlaces', AppEnlace.where(owner_class: 'AppPerfil', owner_id: perfil_activo.id).order(:descripcion), false)
    when 'Calendario' #Variables del calendario
      # verifica calendarios activos
      verifica_annio_activo

      @primer_annio = CalAnnio.all.order(:cal_annio).first.cal_annio
      @ultimo_annio = CalAnnio.all.order(:cal_annio).last.cal_annio
      @annio_activo = params[:a].blank? ? CalAnnio.find_by(cal_annio: Time.zone.today.year) : CalAnnio.find_by(cal_annio: params[:a])

      set_tabla('cal_meses', @annio_activo.cal_meses.order(:cal_mes), false)
      set_tabla('cal_feriados', @annio_activo.cal_feriados.order(:cal_fecha), false)
    when 'Agenda' #Variables del calendario
      set_tabla('age_usuarios', AgeUsuario.where(owner_class: '', owner_id: nil), true)
    when 'Tarifas generales' #Tarifas Generales
      set_tabla('tar_tarifas', TarTarifa.where(owner_class: ''), false)
      set_tabla('tar_servicios', TarServicio.where(owner_class: ''), false)
    when 'Tipos' # Tipos
      set_tabla('tipo_causas', TipoCausa.all.order(:tipo_causa), false)
      set_tabla('tipo_asesorias', TipoAsesoria.all.order(:tipo_asesoria), false)
    when 'Cuantías & Tribunales' #Tablas secundarias
      set_tabla('tar_detalle_cuantias', TarDetalleCuantia.all.order(:tar_detalle_cuantia), false)
      set_tabla('tribunal_cortes', TribunalCorte.all.order(:tribunal_corte), false)
    when 'Modelo'
      if usuario_signed_in?
        # Repositorio de la plataforma
        general_sha1 = Digest::SHA1.hexdigest("Modelo de Negocios General")
        @modelo = MModelo.find_by(m_modelo: general_sha1)
        @modelo = MModelo.create(m_modelo: general_sha1) if @modelo.blank?

        set_tabla('m_cuentas', @modelo.m_cuentas.order(:m_cuenta), false)
      end
    when 'Periodos & Bancos' # Tablas secundarias Modelo
      set_tabla('m_bancos', MBanco.all.order(:m_banco), false) 
      set_tabla('m_periodos', MPeriodo.order(clave: :desc), false) 
    when 10 # Documentos controlados
      set_tabla('st_modelos', StModelo.order(:st_modelo), false)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
end
