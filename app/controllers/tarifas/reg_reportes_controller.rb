class Tarifas::RegReportesController < ApplicationController
  before_action :set_reg_reporte, only: %i[ show edit update destroy cambia_estado]

  # GET /reg_reportes or /reg_reportes.json
  def index
  end

  # GET /reg_reportes/1 or /reg_reportes/1.json
  def show
    set_tabla('registros', @objeto.registros, false)
    set_tabla('tar_facturaciones', @objeto.facturaciones, false)
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

  def cambia_estado
    @objeto.estado = params[:estado]
    @objeto.save

    redirect_to "/#{@objeto.owner.class.name.downcase.pluralize}/#{@objeto.owner.id}?html_options[tab]=Reportes"
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
