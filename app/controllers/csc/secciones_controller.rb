class Csc::SeccionesController < ApplicationController
  before_action :set_seccion, only: %i[ show edit update destroy ]

  # GET /secciones or /secciones.json
  def index
    @coleccion = Seccion.all
  end

  # GET /secciones/1 or /secciones/1.json
  def show
  end

  # GET /secciones/new
  def new
    @objeto = Seccion.new
  end

  # GET /secciones/1/edit
  def edit
  end

  # POST /secciones or /secciones.json
  def create
    @objeto = Seccion.new(seccion_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to seccion_url(@objeto), notice: "Seccion was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /secciones/1 or /secciones/1.json
  def update
    respond_to do |format|
      if @objeto.update(seccion_params)
        format.html { redirect_to seccion_url(@objeto), notice: "Seccion was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /secciones/1 or /secciones/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to secciones_url, notice: "Seccion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_seccion
      @objeto = Seccion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def seccion_params
      params.require(:seccion).permit(:causa_id, :orden, :seccion, :texto)
    end
end
