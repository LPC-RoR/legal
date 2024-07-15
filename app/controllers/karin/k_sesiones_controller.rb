class Karin::KSesionesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_k_sesion, only: %i[ show edit update destroy borrar_encuesta ]

  # GET /k_sesiones or /k_sesiones.json
  def index
    @coleccion = KSesion.all
  end

  # GET /k_sesiones/1 or /k_sesiones/1.json
  def show
  end

  # GET /k_sesiones/new
  def new
    @objeto = KSesion.new
  end

  # GET /k_sesiones/1/edit
  def edit
  end

  # POST /k_sesiones or /k_sesiones.json
  def create
    @objeto = KSesion.new(k_sesion_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to k_sesion_url(@objeto), notice: "Sesion fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /k_sesiones/1 or /k_sesiones/1.json
  def update
    respond_to do |format|
      if @objeto.update(k_sesion_params)
        format.html { redirect_to k_sesion_url(@objeto), notice: "Sesion fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def borrar_encuesta
    @objeto.respuestas.delete_all

    redirect_to '/publicos/encuesta', notice: 'Encuesta borrada exitósamente'
  end

  # DELETE /k_sesiones/1 or /k_sesiones/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to k_sesiones_url, notice: "Sesion fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_k_sesion
      @objeto = KSesion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def k_sesion_params
      params.require(:k_sesion).permit(:fecha, :sesion)
    end
end
