class Tarifas::TarDetalleCuantiasController < ApplicationController
  before_action :set_tar_detalle_cuantia, only: %i[ show edit update destroy ]

  # GET /tar_detalle_cuantias or /tar_detalle_cuantias.json
  def index
  end

  # GET /tar_detalle_cuantias/1 or /tar_detalle_cuantias/1.json
  def show
  end

  # GET /tar_detalle_cuantias/new
  def new
    @objeto = TarDetalleCuantia.new
  end

  # GET /tar_detalle_cuantias/1/edit
  def edit
  end

  # POST /tar_detalle_cuantias or /tar_detalle_cuantias.json
  def create
    @objeto = TarDetalleCuantia.new(tar_detalle_cuantia_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar detalle cuantia was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_detalle_cuantias/1 or /tar_detalle_cuantias/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_detalle_cuantia_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar detalle cuantia was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_detalle_cuantias/1 or /tar_detalle_cuantias/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tar detalle cuantia was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_detalle_cuantia
      @objeto = TarDetalleCuantia.find(params[:id])
    end

    def set_redireccion
      @redireccion = app_enlaces_path
    end

    # Only allow a list of trusted parameters through.
    def tar_detalle_cuantia_params
      params.require(:tar_detalle_cuantia).permit(:tar_detalle_cuantia, :descripcion)
    end
end
