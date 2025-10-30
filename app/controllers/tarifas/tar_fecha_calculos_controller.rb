class Tarifas::TarFechaCalculosController < ApplicationController
  before_action :set_tar_fecha_calculo, only: %i[ show edit update destroy ]

  # GET /tar_fecha_calculos or /tar_fecha_calculos.json
  def index
    @tar_fecha_calculos = TarFechaCalculo.all
  end

  # GET /tar_fecha_calculos/1 or /tar_fecha_calculos/1.json
  def show
  end

  # GET /tar_fecha_calculos/new
  def new
    @tar_fecha_calculo = TarFechaCalculo.new
  end

  # GET /tar_fecha_calculos/1/edit
  def edit
  end

  # POST /tar_fecha_calculos or /tar_fecha_calculos.json
  def create
    @tar_fecha_calculo = TarFechaCalculo.new(tar_fecha_calculo_params)

    respond_to do |format|
      if @tar_fecha_calculo.save
        format.html { redirect_to @tar_fecha_calculo, notice: "Tar fecha calculo was successfully created." }
        format.json { render :show, status: :created, location: @tar_fecha_calculo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tar_fecha_calculo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_fecha_calculos/1 or /tar_fecha_calculos/1.json
  def update
    respond_to do |format|
      if @tar_fecha_calculo.update(tar_fecha_calculo_params)
        format.html { redirect_to @tar_fecha_calculo, notice: "Tar fecha calculo was successfully updated." }
        format.json { render :show, status: :ok, location: @tar_fecha_calculo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tar_fecha_calculo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_fecha_calculos/1 or /tar_fecha_calculos/1.json
  def destroy
    @tar_fecha_calculo.destroy!

    respond_to do |format|
      format.html { redirect_to tar_fecha_calculos_path, status: :see_other, notice: "Tar fecha calculo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_fecha_calculo
      @tar_fecha_calculo = TarFechaCalculo.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def tar_fecha_calculo_params
      params.expect(tar_fecha_calculo: [ :ownr_type, :ownr_id, :fecha, :codigo_formula ])
    end
end
