class Tarifas::TarLiquidacionesController < ApplicationController
  before_action :set_tar_liquidacion, only: %i[ show edit update destroy ]

  # GET /tar_liquidaciones or /tar_liquidaciones.json
  def index
  end

  # GET /tar_liquidaciones/1 or /tar_liquidaciones/1.json
  def show
  end

  # GET /tar_liquidaciones/new
  def new
    @objeto = TarLiquidacion.new
  end

  # GET /tar_liquidaciones/1/edit
  def edit
  end

  # POST /tar_liquidaciones or /tar_liquidaciones.json
  def create
    @objeto = TarLiquidacion.new(tar_liquidacion_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Tar liquidacion was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_liquidaciones/1 or /tar_liquidaciones/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_liquidacion_params)
        format.html { redirect_to @objeto, notice: "Tar liquidacion was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_liquidaciones/1 or /tar_liquidaciones/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to tar_liquidaciones_url, notice: "Tar liquidacion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_liquidacion
      @objeto = TarLiquidacion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tar_liquidacion_params
      params.require(:tar_liquidacion).permit(:liquidacion, :owner_class, :owner_id)
    end
end
