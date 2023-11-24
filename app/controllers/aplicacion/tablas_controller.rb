class Aplicacion::TablasController < ApplicationController
  #before_action :set_tabla, only: %i[ show edit update destroy ]

  # GET /tablas or /tablas.json
  def index

    @indice = params[:tb].blank? ? first_tabla_index : params[:tb].to_i

    case @indice
    when 1 #UF & Regiones
      init_tabla('tar_uf_sistemas', TarUfSistema.all.order(fecha: :desc), false)
      add_tabla('regiones', Region.order(:orden), false)
    when 2 #Enlaces
      init_tabla('app_enlaces', AppEnlace.where(owner_id: nil).order(:descripcion), false)
      add_tabla('perfil-app_enlaces', AppEnlace.where(owner_class: 'AppPerfil', owner_id: perfil_activo.id).order(:descripcion), false)
    when 4 #Tarifas Generales
      init_tabla('tar_tarifas', TarTarifa.where(owner_class: ''), false)
      add_tabla('tar_servicios', TarServicio.where(owner_class: ''), false)
    when 5 #Tablas secundarias
      init_tabla('tar_detalle_cuantias', TarDetalleCuantia.all.order(:tar_detalle_cuantia), false)
      add_tabla('tribunal_cortes', TribunalCorte.all.order(:tribunal_corte), false)
      add_tabla('tipo_causas', TipoCausa.all.order(:tipo_causa), false)
    when 7
      if usuario_signed_in?
        # Repositorio de la plataforma
        general_sha1 = Digest::SHA1.hexdigest("Modelo de Negocios General")
        @modelo = MModelo.find_by(m_modelo: general_sha1)
        @modelo = MModelo.create(m_modelo: general_sha1) if @modelo.blank?

        init_tabla('m_cuentas', @modelo.m_cuentas.order(:m_cuenta), false)

#        init_tabla('m_conceptos', @modelo.m_conceptos.order(:orden), false)
#        add_tabla('m_bancos', MBanco.all.order(:m_banco), false) 
#        add_tabla('m_periodos', MPeriodo.order(clave: :desc), false) 
      end
    when 8 # Tablas secundarias Modelo
      init_tabla('m_bancos', MBanco.all.order(:m_banco), false) 
      add_tabla('m_periodos', MPeriodo.order(clave: :desc), false) 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
end
