class TarDetCuantiaControlesController < ApplicationController
  before_action :set_tar_det_cuantia_control, only: %i[ show edit update destroy ]

  # GET /tar_det_cuantia_controles or /tar_det_cuantia_controles.json
  def index
    @tar_det_cuantia_controles = TarDetCuantiaControl.all
  end

  # GET /tar_det_cuantia_controles/1 or /tar_det_cuantia_controles/1.json
  def show
  end

  # GET /tar_det_cuantia_controles/new
  def new
    @tar_det_cuantia_control = TarDetCuantiaControl.new
  end

  # GET /tar_det_cuantia_controles/1/edit
  def edit
  end

  # POST /tar_det_cuantia_controles or /tar_det_cuantia_controles.json
  def create
    @tar_det_cuantia_control = TarDetCuantiaControl.new(tar_det_cuantia_control_params)

    respond_to do |format|
      if @tar_det_cuantia_control.save
        format.html { redirect_to @tar_det_cuantia_control, notice: "Tar det cuantia control was successfully created." }
        format.json { render :show, status: :created, location: @tar_det_cuantia_control }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tar_det_cuantia_control.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_det_cuantia_controles/1 or /tar_det_cuantia_controles/1.json
  def update
    respond_to do |format|
      if @tar_det_cuantia_control.update(tar_det_cuantia_control_params)
        format.html { redirect_to @tar_det_cuantia_control, notice: "Tar det cuantia control was successfully updated." }
        format.json { render :show, status: :ok, location: @tar_det_cuantia_control }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tar_det_cuantia_control.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_det_cuantia_controles/1 or /tar_det_cuantia_controles/1.json
  def destroy
    @tar_det_cuantia_control.destroy
    respond_to do |format|
      format.html { redirect_to tar_det_cuantia_controles_url, notice: "Tar det cuantia control was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_det_cuantia_control
      @tar_det_cuantia_control = TarDetCuantiaControl.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tar_det_cuantia_control_params
      params.require(:tar_det_cuantia_control).permit(:tar_detalle_cuantia_id, :control_documento_id)
    end
end
