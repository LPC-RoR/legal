class Karin::KrnLstModificacionesController < ApplicationController
  before_action :set_krn_lst_modificacion, only: %i[ show edit update destroy ]

  # GET /krn_lst_modificaciones or /krn_lst_modificaciones.json
  def index
    @krn_lst_modificaciones = KrnLstModificacion.all
  end

  # GET /krn_lst_modificaciones/1 or /krn_lst_modificaciones/1.json
  def show
  end

  # GET /krn_lst_modificaciones/new
  def new
    @krn_lst_modificacion = KrnLstModificacion.new
  end

  # GET /krn_lst_modificaciones/1/edit
  def edit
  end

  # POST /krn_lst_modificaciones or /krn_lst_modificaciones.json
  def create
    @krn_lst_modificacion = KrnLstModificacion.new(krn_lst_modificacion_params)

    respond_to do |format|
      if @krn_lst_modificacion.save
        format.html { redirect_to krn_lst_modificacion_url(@krn_lst_modificacion), notice: "Krn lst modificacion was successfully created." }
        format.json { render :show, status: :created, location: @krn_lst_modificacion }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @krn_lst_modificacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_lst_modificaciones/1 or /krn_lst_modificaciones/1.json
  def update
    respond_to do |format|
      if @krn_lst_modificacion.update(krn_lst_modificacion_params)
        format.html { redirect_to krn_lst_modificacion_url(@krn_lst_modificacion), notice: "Krn lst modificacion was successfully updated." }
        format.json { render :show, status: :ok, location: @krn_lst_modificacion }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @krn_lst_modificacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_lst_modificaciones/1 or /krn_lst_modificaciones/1.json
  def destroy
    @krn_lst_modificacion.destroy!

    respond_to do |format|
      format.html { redirect_to krn_lst_modificaciones_url, notice: "Krn lst modificacion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_lst_modificacion
      @krn_lst_modificacion = KrnLstModificacion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def krn_lst_modificacion_params
      params.require(:krn_lst_modificacion).permit(:ownr_id, :ownr_type, :emisor)
    end
end
