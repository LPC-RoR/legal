class TarConveniosController < ApplicationController
  before_action :set_tar_convenio, only: %i[ show edit update destroy ]

  # GET /tar_convenios or /tar_convenios.json
  def index
    @tar_convenios = TarConvenio.all
  end

  # GET /tar_convenios/1 or /tar_convenios/1.json
  def show
  end

  # GET /tar_convenios/new
  def new
    @tar_convenio = TarConvenio.new
  end

  # GET /tar_convenios/1/edit
  def edit
  end

  # POST /tar_convenios or /tar_convenios.json
  def create
    @tar_convenio = TarConvenio.new(tar_convenio_params)

    respond_to do |format|
      if @tar_convenio.save
        format.html { redirect_to @tar_convenio, notice: "Tar convenio was successfully created." }
        format.json { render :show, status: :created, location: @tar_convenio }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tar_convenio.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_convenios/1 or /tar_convenios/1.json
  def update
    respond_to do |format|
      if @tar_convenio.update(tar_convenio_params)
        format.html { redirect_to @tar_convenio, notice: "Tar convenio was successfully updated." }
        format.json { render :show, status: :ok, location: @tar_convenio }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tar_convenio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_convenios/1 or /tar_convenios/1.json
  def destroy
    @tar_convenio.destroy
    respond_to do |format|
      format.html { redirect_to tar_convenios_url, notice: "Tar convenio was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_convenio
      @tar_convenio = TarConvenio.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tar_convenio_params
      params.require(:tar_convenio).permit(:fecha, :monto, :estado, :tar_factura_id)
    end
end
