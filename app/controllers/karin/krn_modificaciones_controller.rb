class KrnModificacionesController < ApplicationController
  before_action :set_krn_modificacion, only: %i[ show edit update destroy ]

  # GET /krn_modificaciones or /krn_modificaciones.json
  def index
    @krn_modificaciones = KrnModificacion.all
  end

  # GET /krn_modificaciones/1 or /krn_modificaciones/1.json
  def show
  end

  # GET /krn_modificaciones/new
  def new
    @krn_modificacion = KrnModificacion.new
  end

  # GET /krn_modificaciones/1/edit
  def edit
  end

  # POST /krn_modificaciones or /krn_modificaciones.json
  def create
    @krn_modificacion = KrnModificacion.new(krn_modificacion_params)

    respond_to do |format|
      if @krn_modificacion.save
        format.html { redirect_to krn_modificacion_url(@krn_modificacion), notice: "Krn modificacion was successfully created." }
        format.json { render :show, status: :created, location: @krn_modificacion }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @krn_modificacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_modificaciones/1 or /krn_modificaciones/1.json
  def update
    respond_to do |format|
      if @krn_modificacion.update(krn_modificacion_params)
        format.html { redirect_to krn_modificacion_url(@krn_modificacion), notice: "Krn modificacion was successfully updated." }
        format.json { render :show, status: :ok, location: @krn_modificacion }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @krn_modificacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_modificaciones/1 or /krn_modificaciones/1.json
  def destroy
    @krn_modificacion.destroy!

    respond_to do |format|
      format.html { redirect_to krn_modificaciones_url, notice: "Krn modificacion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_modificacion
      @krn_modificacion = KrnModificacion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def krn_modificacion_params
      params.require(:krn_modificacion).permit(:krn_lst_modificacion_id, :krn_medida_id, :detalle)
    end
end
