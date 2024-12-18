class Actividades::AgeActividadesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_age_actividad, only: %i[ show edit update destroy suma_participante resta_participante realizada_pendiente cambia_prioridad cambia_estado cambia_privada cambio_fecha sspndr]
  after_action :elimina_fecha_audiencia, only: :destroy
  after_action :set_fecha_audiencia, only: %i[ create update ]

  # GET /age_actividades or /age_actividades.json
  def index
    # Manejo actual de age_usuarios
    @usuario = perfil_activo.age_usuario

    @age_usuarios = AgeUsuario.where(owner_class: nil, owner_id: nil)

    set_tab( :tab, ['Pendientes', 'Realizados'])
    @estado = @options[:tab].singularize.downcase

    unless @usuario.blank?
      if @options[:tab] == 'Pendientes'
        set_tabla('d-age_pendientes', @usuario.age_pendientes.where(estado: 'pendiente', prioridad: 'danger').order(:created_at), false)
        set_tabla('w-age_pendientes', @usuario.age_pendientes.where(estado: 'pendiente', prioridad: 'warning').order(:created_at), false)
        set_tabla('s-age_pendientes', @usuario.age_pendientes.where(estado: 'pendiente', prioridad: 'success').order(:created_at), false)
        set_tabla('n-age_pendientes', @usuario.age_pendientes.where(estado: 'pendiente', prioridad: nil).order(:created_at), false)
      else
        set_tabla('r-age_pendientes', @usuario.age_pendientes.where(estado: 'realizado', prioridad: nil).order(updated_at: :desc), false)
      end
    end
 
    # concerns/calendario#load_calendario
    load_calendario

  end

  # GET /age_actividades/1 or /age_actividades/1.json
  def show
  end

  # GET /age_actividades/new
  def new
    ownr = params[:oid].blank? ? nil : params[:oclss].constantize.find(params[:oid])
    if ['prprtr', 'unc', 'jc'].include?(params[:k])
      tipo = 'Audiencia'
      age_actividad = 'Audiencia de juicio' if params[:k] == 'jc'
      age_actividad = 'Audiencia preparatoria' if params[:k] == 'prprtr'
      age_actividad = 'Audiencia única' if params[:k] == 'unc'
    elsif params[:k] == 'rnn'
      tipo = 'Reunión'
    end
    @objeto = AgeActividad.new(ownr_type: params[:oclss], ownr_id: params[:oid], app_perfil_id: perfil_activo.id, age_actividad: age_actividad, estado: 'pendiente', tipo: tipo)
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
      mensaje = 'Actividad fue creada exitósamente'

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

    redirect_to "/#{params[:cn]}/#{params[:oid]}", notice: mensaje
  end

  def cambia_privada
    @objeto.privada = ( not @objeto.privada )
    @objeto.save    

    redirect_to params[:cn] == 'age_actividades' ? "/age_actividades" : @objeto.owner
  end

  # DEPRECATED
  def crea_audiencia
    causa = params[:class_name].constantize.find(params[:objeto_id])
    AgeActividad.create(age_actividad: params[:label] ,owner_class: params[:class_name], owner_id: params[:objeto_id], app_perfil_id: perfil_activo.id, estado: 'ingreso', tipo: 'Audiencia')

    redirect_to causa
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
        format.html { redirect_to @rdrccn, notice: "Actividad fue exitósamente creada." }
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
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Actividad fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def cambia_prioridad
    # {negro, verde, amarillo, rojo}
    @objeto.prioridad = params[:prioridad] == 'nil' ? nil : params[:prioridad]
    @objeto.save

    redirect_to ( params[:cn] == 'age_actividades' ? '/age_actividades' : @objeto.owner )
  end

  def cambia_estado
    # {negro, verde, amarillo, rojo}
    @objeto.estado = params[:e]
    @objeto.save

    redirect_to ( params[:cn] == 'age_actividades' ? '/age_actividades' : @objeto.owner )
  end

  def suma_participante
    perfil = AppPerfil.find(params[:pid])
    @objeto.app_perfiles << perfil

    redirect_to ( params[:loc] == 'age_actividades' ? '/age_actividades' : @objeto.owner )
  end

  def resta_participante
    perfil = AppPerfil.find(params[:pid])
    @objeto.app_perfiles.delete(perfil)

    redirect_to ( params[:loc] == 'age_actividades' ? '/age_actividades' : @objeto.owner )
  end

  def cambio_fecha
    prms = params[:form_cambio_fecha]
    unless prms['nueva_fecha(3i)'].blank? or prms['nueva_fecha(2i)'].blank? or prms['nueva_fecha(1i)'].blank?
      # crea LOG
      # Agregar email del usuario que cambió la fecha
      log = @objeto.age_logs.create(fecha: @objeto.fecha, actividad: @objeto.age_actividad)
      unless log.blank?
        @objeto.fecha = params_to_date(prms, 'nueva_fecha')
        @objeto.estado = 'pendiente' if @objeto.estado == 'suspendida'
        @objeto.save

        set_fecha_audiencia

      end
    end

    get_rdrccn
    redirect_to @rdrccn
  end

  def sspndr
    if ['suspendida', 'pendiente'].include?(@objeto.estado)
      @objeto.estado = 'suspendida'
      @objeto.save
      causa = @objeto.ownr
      causa.fecha_audiencia = nil
      causa.save
    end
    
    set_redireccion
    redirect_to @redireccion
  end

  # DELETE /age_actividades/1 or /age_actividades/1.json
  def destroy
    get_rdrccn
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Actividad fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private

    # Métodos para mantener campo fecha_audiencia que determina el orden
    def elimina_fecha_audiencia
      if @objeto.tipo == 'Audiencia'
        ownr = @objeto.ownr
        unless ownr.blank?
          ultimo = ownr.age_actividades.udncs.fecha_ordr.last
          if ultimo.blank?
            ownr.fecha_audiencia = nil
            ownr.audiencia = nil
          else
            ownr.fecha_audiencia = ultimo.fecha
            ownr.audiencia = ultimo.age_actividad
          end
          ownr.save
        end
      end
    end

    def set_fecha_audiencia
      if @objeto.tipo == 'Audiencia'
        ownr = @objeto.ownr
        ownr.fecha_audiencia = @objeto.fecha
        ownr.audiencia = @objeto.age_actividad
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

    # Only allow a list of trusted parameters through.
    def age_actividad_params
      params.require(:age_actividad).permit(:age_actividad, :tipo, :app_perfil_id, :ownr_type, :ownr_id, :estado, :fecha, :privada, :audiencia_especial)
    end
end
