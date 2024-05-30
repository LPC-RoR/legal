class Actividades::AgeActividadesController < ApplicationController
  before_action :set_age_actividad, only: %i[ show edit update destroy suma_participante resta_participante agrega_antecedente realizada_pendiente cambia_prioridad cambia_estado cambia_privada asigna_usuario desasigna_usuario, cambio_fecha]

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
    set_tabla('age_antecedentes', @objeto.age_antecedentes.order(:orden), false)
  end

  # GET /age_actividades/new
  def new
    case params[:t]
    when 'A'
      tipo = 'Audiencia'
    when 'R'
      tipo = 'Reunión'
    when 'T'
      tipo = 'Tarea'
    when 'H'
      tipo = 'Hito'
    end
    @objeto = AgeActividad.new(owner_class: params[:class_name], owner_id: params[:objeto_id], app_perfil_id: perfil_activo.id, estado: 'pendiente', tipo: tipo)
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
      owner_id = params[:oid]
      owner_class = owner_id.blank? ? nil : params[:cn].classify
      fecha = Time.zone.parse("#{f_params['fecha(3i)']}-#{mes}-#{annio} #{hora}:#{minutos}")
      audiencia_especial = f_params[:audiencia_especial]
      privada = f_params[:privada]

      AgeActividad.create(app_perfil_id: app_perfil_id, owner_class: owner_class, owner_id: owner_id, tipo: tipo, age_actividad: age_actividad, fecha: fecha, estado: 'pendiente', privada: privada, audiencia_especial: audiencia_especial)
      mensaje = 'Actividad fue creada exitósamente'
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
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Actividad fue exitósamente creada." }
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
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Actividad fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def asigna_usuario
    usuario = AgeUsuario.find(params[:uid])
    @objeto.age_usuarios << usuario unless usuario.blank?
    
    if params[:cn] == 'age_actividades'
      redirect_to "/age_actividades"
    else
      redirect_to @objeto.owner
    end
  end

  def desasigna_usuario
    usuario = AgeUsuario.find(params[:uid])
    @objeto.age_usuarios.delete(usuario) unless usuario.blank?
    
    if params[:cn] == 'age_actividades'
      redirect_to "/age_actividades"
    else
      redirect_to @objeto.owner
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

  # Ahora se llama agregar nota 25 mayo 2024
  def agrega_antecedente
    prms = params[:form_antecedente]
    unless prms[:nota].blank? 
      @objeto.age_antecedentes.create(nota: prms[:nota], tipo: prms[:tipo], email: perfil_activo.email, orden: @objeto.age_antecedentes.count + 1)
    end

    redirect_to ( params[:c] == 'age_actividades' ? '/age_actividades' : @objeto.owner )
  end

  def cambio_fecha
    prms = params[:form_cambio_fecha]
    unless prms['nueva_fecha(3i)'].blank? or prms['nueva_fecha(2i)'].blank? or prms['nueva_fecha(1i)'].blank?
      # crea LOG
      # Agregar email del usuario que cambió la fecha
      log = @objeto.age_logs.create(fecha: @objeto.fecha, actividad: @objeto.age_actividad)
      unless log.blank?
        @objeto.fecha = params_to_date(prms, 'nueva_fecha')
        @objeto.save
      end
    end

    set_redireccion
    redirect_to @redireccion
  
  end

  # DELETE /age_actividades/1 or /age_actividades/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Actividad fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_age_actividad
      @objeto = AgeActividad.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.owner_id.blank? ? "/age_actividades" : @objeto.owner
    end

    # Only allow a list of trusted parameters through.
    def age_actividad_params
      params.require(:age_actividad).permit(:age_actividad, :tipo, :app_perfil_id, :owner_class, :owner_id, :estado, :fecha, :privada, :audiencia_especial)
    end
end
