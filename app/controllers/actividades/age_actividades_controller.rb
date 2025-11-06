class Actividades::AgeActividadesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_age_actividad, only: %i[ show edit update destroy swtch dssgn_usr assgn_usr cambia_estado cambio_fecha ]
  after_action :set_fecha_audiencia, only: %i[ create update ]

  layout 'addt'

  include AgeUsr

  # GET /age_actividades or /age_actividades.json
  def index
    # Manejo actual de age_usuarios
    @usuario = perfil_activo.age_usuario

    @usrs = Usuario.where(tenant_id: nil)
#    @age_usuarios = AgeUsuario.where(owner_class: nil, owner_id: nil)

    set_tab( :tab, ['Pendientes', 'Realizados'])
    @estado = @options[:tab].singularize.downcase

    if @options[:tab] == 'Pendientes'
      set_tabla('d-age_pendientes', @usuario.age_pendientes.where(estado: 'pendiente', prioridad: 'danger').order(:created_at), false)
      set_tabla('w-age_pendientes', @usuario.age_pendientes.where(estado: 'pendiente', prioridad: 'warning').order(:created_at), false)
      set_tabla('s-age_pendientes', @usuario.age_pendientes.where(estado: 'pendiente', prioridad: 'success').order(:created_at), false)
      set_tabla('n-age_pendientes', @usuario.age_pendientes.where(estado: 'pendiente', prioridad: nil).order(:created_at), false)
    else
      set_tabla('r-age_pendientes', @usuario.age_pendientes.where(estado: 'realizado', prioridad: nil).order(updated_at: :desc), false)
    end
 
    # concerns/calendario#load_calendario
    load_calendario

  end

  # GET /age_actividades/1 or /age_actividades/1.json
  def show
  end

  # GET /age_actividades/new
  def new
    # AgeActividad NO tiene usuario_id: las actividades NO registran el usuario que las creo
    ownr = params[:oid].blank? ? nil : params[:oclss].constantize.find(params[:oid])
    tipo = ClssActvdd.tipo(params[:k])
    actvdd = ClssActvdd.actvdd[params[:k]]
    @objeto = AgeActividad.new(ownr_type: params[:oclss], ownr_id: params[:oid], age_actividad: actvdd, estado: 'pendiente', tipo: tipo)
  end

  def cu_actividad
    f_params = params[:form_actividad]

    # defauls datetime fields
    hoy = Time.zone.today
    annio = f_params['fecha(1i)'].blank? ? hoy.year : f_params['fecha(1i)']
    mes = f_params['fecha(2i)'].blank? ? hoy.month : f_params['fecha(2i)']
    hora = f_params['fecha(4i)']
    minutos = f_params['fecha(5i)']

    age_actividad = params[:t] == 'A' ? params[:aud] : f_params[:age_actividad]

    unless age_actividad.blank? or f_params['fecha(3i)'].blank?
      tipo = params[:t].blank? ? f_params[:tipo] : (params[:t] == 'A' ? 'Audiencia' : ( params[:t] == 'H' ? 'Hito' : ( params[:t] == 'R' ? 'Reunión' : 'Tarea' ) ))
      app_perfil_id = perfil_activo.id
      ownr_id = params[:oid]
      ownr_type = ownr_id.blank? ? nil : params[:cn].classify
      fecha = Time.zone.parse("#{f_params['fecha(3i)']}-#{mes}-#{annio} #{hora}:#{minutos}")
      audiencia_especial = f_params[:audiencia_especial]
      privada = f_params[:privada]

      AgeActividad.create(app_perfil_id: app_perfil_id, ownr_type: ownr_type, ownr_id: ownr_id, tipo: tipo, age_actividad: age_actividad, fecha: fecha, estado: 'pendiente', privada: privada, audiencia_especial: audiencia_especial)
      mensaje = 'Actividad fue creada exitosamente'

      if params[:t] == 'A'
        causa = Causa.find(params[:oid])
        unless causa.blank?
          causa.fecha_audiencia = fecha
          causa.audiencia = params[:aud]
          causa.save
        end
      end
    else
      mensaje = 'Error de ingreso Actividad: Fecha y Descripción son campos obligatorios'
    end

    redirect_to orgn_path, notice: mensaje
  end

  # GET /age_actividades/1/edit
  def edit
  end

  # POST /age_actividades or /age_actividades.json
  def create
    @objeto = AgeActividad.new(age_actividad_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to orgn_path, notice: "Actividad fue exitosamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /age_actividades/1 or /age_actividades/1.json
  def update
    respond_to do |format|
      if @objeto.update(age_actividad_params)
        format.html { redirect_to orgn_path, notice: "Actividad fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def cambia_estado
    # {negro, verde, amarillo, rojo}
    @objeto.estado = params[:e]
    @objeto.save

    redirect_to ( params[:cn] == 'age_actividades' ? '/age_actividades' : @objeto.owner )
  end

  def cambio_fecha
    prms = params[:form_cambio_fecha]
    if prms[:nueva_fecha]
      # crea LOG
      # Agregar email del usuario que cambió la fecha
      log = @objeto.age_logs.create(fecha: @objeto.fecha, actividad: @objeto.age_actividad)
      unless log.blank?
        @objeto.fecha = Date.parse(prms[:nueva_fecha])
        @objeto.estado = 'pendiente' if @objeto.estado == 'suspendida'
        @objeto.save

        set_fecha_audiencia

      end
    end

    redirect_to orgn_path
  end

  # DELETE /age_actividades/1 or /age_actividades/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to orgn_path, notice: "Actividad fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  private

    def set_fecha_audiencia
      if @objeto.tipo == 'Audiencia'
        ownr = @objeto.ownr
        adncs = ownr.age_actividades.adncs.ftrs.fecha_ordr
        ownr.fecha_audiencia = adncs.empty? ? nil : adncs.first.fecha
        ownr.audiencia = adncs.empty? ? nil : adncs.first.age_actividad

        ownr.estado = ownr.get_estado
        ownr.save
      end
    end

    # ---------------------------------------------------------------------

    # Use callbacks to share common setup or constraints between actions.
    def set_age_actividad
      @objeto = AgeActividad.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = @objeto.ownr_id.blank? ? "/age_actividades" : @objeto.ownr
    end

    def orgn_path
      case params[:orgn]
      when 'dshbrd'
        authenticated_root_path
      when 'cs_shw'
        @objeto.ownr
      else
        @objeto.ownr_id.blank? ? "/age_actividades" : @objeto.ownr
      end
    end

    # Only allow a list of trusted parameters through.
    def age_actividad_params
      params.require(:age_actividad).permit(:age_actividad, :tipo, :app_perfil_id, :ownr_type, :ownr_id, :estado, :fecha, :privada, :audiencia_especial)
    end
end
