class KrnMotivoDerivacionesController < ApplicationController
  before_action :set_krn_motivo_derivacion, only: %i[ show edit update destroy ]

  # GET /krn_motivo_derivaciones or /krn_motivo_derivaciones.json
  def index
    @krn_motivo_derivaciones = KrnMotivoDerivacion.all
  end

  # GET /krn_motivo_derivaciones/1 or /krn_motivo_derivaciones/1.json
  def show
  end

  # GET /krn_motivo_derivaciones/new
  def new
    @krn_motivo_derivacion = KrnMotivoDerivacion.new
  end

  # GET /krn_motivo_derivaciones/1/edit
  def edit
  end

  # POST /krn_motivo_derivaciones or /krn_motivo_derivaciones.json
  def create
    @krn_motivo_derivacion = KrnMotivoDerivacion.new(krn_motivo_derivacion_params)

    respond_to do |format|
      if @krn_motivo_derivacion.save
        format.html { redirect_to krn_motivo_derivacion_url(@krn_motivo_derivacion), notice: "Krn motivo derivacion was successfully created." }
        format.json { render :show, status: :created, location: @krn_motivo_derivacion }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @krn_motivo_derivacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_motivo_derivaciones/1 or /krn_motivo_derivaciones/1.json
  def update
    respond_to do |format|
      if @krn_motivo_derivacion.update(krn_motivo_derivacion_params)
        format.html { redirect_to krn_motivo_derivacion_url(@krn_motivo_derivacion), notice: "Krn motivo derivacion was successfully updated." }
        format.json { render :show, status: :ok, location: @krn_motivo_derivacion }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @krn_motivo_derivacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_motivo_derivaciones/1 or /krn_motivo_derivaciones/1.json
  def destroy
    @krn_motivo_derivacion.destroy!

    respond_to do |format|
      format.html { redirect_to krn_motivo_derivaciones_url, notice: "Krn motivo derivacion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_motivo_derivacion
      @krn_motivo_derivacion = KrnMotivoDerivacion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def krn_motivo_derivacion_params
      params.require(:krn_motivo_derivacion).permit(:krn_motivo_derivacion)
    end
end
