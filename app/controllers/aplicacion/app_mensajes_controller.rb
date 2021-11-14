class Aplicacion::AppMensajesController < ApplicationController
  before_action :set_app_mensaje, only: %i[ show edit update destroy estado ]

  # GET /app_mensajes or /app_mensajes.json
  def index

    # Manejo del sidebar
    @e = (params[:e].blank? ? 'ingreso' : params[:e])

    coleccion_base = admin? ? AppMensaje.all : perfil_activo.app_mensajes
    encabezados = coleccion_base.where.not(tipo: 'respuesta')
    autenticados = AppMensaje.where.not(app_perfil_id: nil)

    ids_administrativos = autenticados.map {|aut| aut.id if aut.app_perfil.app_administrador.present?}.compact

    # Despliegue
    @coleccion = {}
    if @e == 'ingreso' and admin?
      @coleccion['app_mensajes'] = coleccion_base.where(id: ids_administrativos).where(estado: 'ingreso').order(fecha_envio: :desc)
    elsif @e == 'cerrado'
      @coleccion['app_mensajes'] = encabezados.where(estado: 'cerrado')
    else
      enviados = encabezados.where(estado: 'enviado')

      ids_con_respuesta = enviados.map {|pend| pend.id if pend.children.any?}.compact
      ids_sin_respuesta = enviados.map {|pend| pend.id if pend.children.empty?}.compact

      if @e == 'enviado'
        @coleccion['app_mensajes'] = enviados.where(id: ids_administrativos).order(fecha_envio: :desc)
      elsif @e == 'recibido'
        ids_usuario_sin_respuesta = (ids_sin_respuesta - ids_administrativos)
        ids_usuario_con_respuesta = (ids_con_respuesta - ids_administrativos)
        usuario_con_respuesta = AppMensaje.where(id: ids_usuario_con_respuesta)
        ## ADMINISTRADOR
        # Los ENVIADOS POR USUARIOS SIN RESPUESTA + CON RESPUESTA CUYA ULTIMA RESPUESTA ES DEL USUARIO
        if admin?
          ids_usuario_con_respuesta_usuario = usuario_con_respuesta.map {|msg| msg.id if msg.children.order(fecha_envio: :desc).first.perfil.administrador.blank?}.compact
          ids_coleccion = (ids_usuario_sin_respuesta | ids_usuario_con_respuesta_usuario)
        ## USUARIO
        # Los ENVIADOS POR LA ADMINSITRACIÖN + ENVIADOS POR USUARIO CUYA ULTIMA RESPUESTA ES DE LA ADMINSITRACIÓN
        else
          ids_enviados_adm = enviados.where(id: ids_administrativos).order(fecha_envio: :desc)
          ids_usuario_con_respuesta_admin = usuario_con_respuesta.map {|msg| msg.id if msg.children.order(fecha_envio: :desc).first.perfil.administrador.present?}.compact
          ids_coleccion = (ids_enviados_adm | ids_usuario_con_respuesta_admin)
        end
        @coleccion[controller_name] = coleccion_base.where(id: ids_coleccion).order(fecha_envio: :desc)
      end

      @coleccion['app_mensajes'] = AppMensaje.where(estado: @e).order(:created_at)
    end

    @nomina = AppNomina.find_by(email: perfil_activo.email) unless seguridad_desde('admin')

  end

  # GET /app_mensajes/1 or /app_mensajes/1.json
  def show
  end

  # GET /app_mensajes/new
  def new
    if usuario_signed_in?
      perfil_id = perfil_activo_id
      tipo      = admin? ? 'administrador' : 'usuario'
      estado    = 'ingreso'
    else
      perfil_id = nil
      tipo      = 'anónimo'
      estado    = 'enviado'
    end

    perfil_id = (usuario_signed_in? ? perfil_activo_id : nil)
    tipo = (usuario_signed_in? ? ( admin? ? 'administrador' : 'usuario') : 'anónimo')
    estado = (usuario_signed_in? ? 'ingreso' : 'enviado')
    
    @objeto = AppMensaje.new(estado: estado, fecha_envio: DateTime.current, app_perfil_id: perfil_id, tipo: tipo)
  end

  # GET /app_mensajes/1/edit
  def edit
  end

  # POST /app_mensajes or /app_mensajes.json
  def create
    @objeto = AppMensaje.new(app_mensaje_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "App mensaje was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def respuesta
    @padre = AppMensaje.find(params[:padre_id])
    perfil_id = perfil_activo_id
    tipo      = admin? ? 'administrador' : 'usuario'
    estado    = 'enviado'
    mensaje = params[:mensaje_base][:mensaje]
    detalle = params[:mensaje_base][:detalle]

    @objeto = AppMensaje.create(estado: estado, fecha_envio: DateTime.current, app_perfil_id: perfil_id, tipo: tipo, mensaje: mensaje, detalle: detalle)
    @padre.children << @objeto

    redirect_to @padre
    
  end

  # PATCH/PUT /app_mensajes/1 or /app_mensajes/1.json
  def update
    respond_to do |format|
      if @objeto.update(app_mensaje_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "App mensaje was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def estado
    unless params[:estado].blank?
      @objeto.estado = params[:estado]
      @objeto.save
    end

    redirect_to @objeto
  end

  # DELETE /app_mensajes/1 or /app_mensajes/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "App mensaje was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_mensaje
      @objeto = AppMensaje.find(params[:id])
    end

    def set_redireccion
      @redireccion = (usuario_signed_in? ? app_mensajes_path : root_path)
    end

    # Only allow a list of trusted parameters through.
    def app_mensaje_params
      params.require(:app_mensaje).permit(:mensaje, :tipo, :estado, :email, :fecha_envio, :detalle, :app_perfil_id)
    end
end
