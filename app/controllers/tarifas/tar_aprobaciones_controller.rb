class Tarifas::TarAprobacionesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_tar_aprobacion, only: %i[ show edit update destroy ]

  layout 'addt'
  
  # GET /tar_aprobaciones or /tar_aprobaciones.json
  def index
    set_tabla('tar_aprobaciones', TarAprobacion.ordr, true)
    set_tabla('tar_calculos', TarCalculo.no_aprbcn, false)
    set_tabla('tar_facturaciones', TarFacturacion.no_aprbcn, false)
  end

  # GET /tar_aprobaciones/1 or /tar_aprobaciones/1.json
  def show
  end

  # GET /tar_aprobaciones/new
  def new
    @objeto = TarAprobacion.new
  end

  # GET /tar_aprobaciones/1/edit
  def edit
  end

  # POST /tar_aprobaciones or /tar_aprobaciones.json
  def create
    @objeto = TarAprobacion.new(tar_aprobacion_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Aprobación fue exitosamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_aprobaciones/1 or /tar_aprobaciones/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_aprobacion_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Aprobación fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_aprobaciones/1 or /tar_aprobaciones/1.json
  def destroy
    get_rdrccn
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Aprobación fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_aprobacion
      @objeto = TarAprobacion.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = tar_aprobaciones_url
    end

    # Only allow a list of trusted parameters through.
    def tar_aprobacion_params
      params.require(:tar_aprobacion).permit(:cliente_id, :fecha)
    end
end
