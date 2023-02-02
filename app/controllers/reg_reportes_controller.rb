class RegReportesController < ApplicationController
  before_action :set_reg_reporte, only: %i[ show edit update destroy ]

  # GET /reg_reportes or /reg_reportes.json
  def index
    @coleccion = RegReporte.all
  end

  # GET /reg_reportes/1 or /reg_reportes/1.json
  def show
    @coleccion = {}
    @coleccion['registros'] = @objeto.registros
  end

  # GET /reg_reportes/new
  def new
    @objeto = RegReporte.new
  end

  # GET /reg_reportes/1/edit
  def edit
  end

  # POST /reg_reportes or /reg_reportes.json
  def create
    @objeto = RegReporte.new(reg_reporte_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Reg reporte was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reg_reportes/1 or /reg_reportes/1.json
  def update
    respond_to do |format|
      if @objeto.update(reg_reporte_params)
        format.html { redirect_to @objeto, notice: "Reg reporte was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reg_reportes/1 or /reg_reportes/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to reg_reportes_url, notice: "Reg reporte was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reg_reporte
      @objeto = RegReporte.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reg_reporte_params
      params.require(:reg_reporte).permit(:clave)
    end
end
