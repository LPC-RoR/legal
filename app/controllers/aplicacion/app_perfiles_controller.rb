class Aplicacion::AppPerfilesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :inicia_sesion
  before_action :set_app_perfil, only: %i[ show edit update destroy desvincular ]

  # GET /app_perfiles or /app_perfiles.json
  def index
    @coleccion = AppPerfil.all
  end

  # GET /app_perfiles/1 or /app_perfiles/1.json
  def show
  end

  # GET /app_perfiles/new
  def new
    @objeto = AppPerfil.new
  end

  # GET /app_perfiles/1/edit
  def edit
  end

  # POST /app_perfiles or /app_perfiles.json
  def create
    @objeto = AppPerfil.new(app_perfil_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "App perfil was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_perfiles/1 or /app_perfiles/1.json
  def update
    respond_to do |format|
      if @objeto.update(app_perfil_params)
        format.html { redirect_to @objeto, notice: "App perfil was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  #  OTRO PROYECTO: REVISAR PARA SACAR O PONER EN UN MEJOR LUGAR
  def desvincular
    proyecto = Proyecto.find(params[:objeto_id])
    @objeto.colaboraciones.delete(proyecto)

    redirect_to '/proyectos/proyecto_activo'
  end

  # DELETE /app_perfiles/1 or /app_perfiles/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to app_perfiles_url, notice: "App perfil was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_perfil
      @objeto = AppPerfil.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def app_perfil_params
      params.require(:app_perfil).permit(:email, :usuario_id, :administrador_id)
    end
end
