class Aplicacion::AppAdministradoresController < ApplicationController
  before_action :authenticate_usuario!
  before_action :inicia_sesion
  before_action :set_app_administrador, only: %i[ show edit update destroy ]
  before_action :carga_solo_sidebar, only: %i[ show new edit create update ]

  include Sidebar

  # GET /app_administradores or /app_administradores.json
  def index
    @coleccion = {}
    @coleccion['app_administradores'] = AppAdministrador.all
  end

  # GET /app_administradores/1 or /app_administradores/1.json
  def show
  end

  # GET /app_administradores/new
  def new
    @objeto = AppAdministrador.new
  end

  # GET /app_administradores/1/edit
  def edit
  end

  # POST /app_administradores or /app_administradores.json
  def create
    @objeto = AppAdministrador.new(app_administrador_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "App administrador was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_administradores/1 or /app_administradores/1.json
  def update
    respond_to do |format|
      if @objeto.update(app_administrador_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "App administrador was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_administradores/1 or /app_administradores/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "App administrador was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_app_administrador
      @objeto = AppAdministrador.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/app_recursos/administracion?id=#{get_elemento_id(controller_name, 'Administradores')}" 
    end

    # Only allow a list of trusted parameters through.
    def app_administrador_params
      params.require(:app_administrador).permit(:administrador, :email, :usuario_id)
    end
end
