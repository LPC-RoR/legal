class Tarifas::TarDetallesController < ApplicationController
  before_action :set_tar_detalle, only: %i[ show edit update destroy ]

  # GET /tar_detalles or /tar_detalles.json
  def index
  end

  # GET /tar_detalles/1 or /tar_detalles/1.json
  def show
  end

  # GET /tar_detalles/new
  def new
    @objeto = TarDetalle.new(tar_tarifa_id: params[:tar_tarifa_id])
  end

  # GET /tar_detalles/1/edit
  def edit
  end

  # POST /tar_detalles or /tar_detalles.json
  def create
    @objeto = TarDetalle.new(tar_detalle_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar detalle was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_detalles/1 or /tar_detalles/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_detalle_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar detalle was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_detalles/1 or /tar_detalles/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tar detalle was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_detalle
      @objeto = TarDetalle.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.tar_tarifa
    end

    # Only allow a list of trusted parameters through.
    def tar_detalle_params
      params.require(:tar_detalle).permit(:orden, :codigo, :detalle, :tipo, :formula, :tar_tarifa_id, :esconder, :total)
    end
end
