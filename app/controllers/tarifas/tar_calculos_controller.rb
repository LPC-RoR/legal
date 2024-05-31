class Tarifas::TarCalculosController < ApplicationController
  before_action :set_tar_calculo, only: %i[ show edit update destroy ]

  # GET /tar_calculos or /tar_calculos.json
  def index
    @coleccion = TarCalculo.all
  end

  # GET /tar_calculos/1 or /tar_calculos/1.json
  def show
  end

  # GET /tar_calculos/new
  def new
    @objeto = TarCalculo.new
  end

  # GET /tar_calculos/1/edit
  def edit
  end

  # POST /tar_calculos or /tar_calculos.json
  def create
    @objeto = TarCalculo.new(tar_calculo_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Tar calculo was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_calculos/1 or /tar_calculos/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_calculo_params)
        format.html { redirect_to @objeto, notice: "Tar calculo was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_calculos/1 or /tar_calculos/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to tar_calculos_url, notice: "Tar calculo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_calculo
      @objeto = TarCalculo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tar_calculo_params
      params.require(:tar_calculo).permit(:clnt_id, :ownr_clss, :ownr_id, :tar_pago_id, :moneda, :monto, :glosa, :cuantia)
    end
end
