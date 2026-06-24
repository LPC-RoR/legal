class CliAprobacionesController < ApplicationController
  before_action :set_cli_aprobacion, only: %i[ show edit update destroy ]

  # GET /cli_aprobaciones or /cli_aprobaciones.json
  def index
    @cli_aprobaciones = CliAprobacion.all
  end

  # GET /cli_aprobaciones/1 or /cli_aprobaciones/1.json
  def show
  end

  # GET /cli_aprobaciones/new
  def new
    @cli_aprobacion = CliAprobacion.new
  end

  # GET /cli_aprobaciones/1/edit
  def edit
  end

  # POST /cli_aprobaciones or /cli_aprobaciones.json
  def create
    @cli_aprobacion = CliAprobacion.new(cli_aprobacion_params)

    respond_to do |format|
      if @cli_aprobacion.save
        format.html { redirect_to @cli_aprobacion, notice: "Cli aprobacion was successfully created." }
        format.json { render :show, status: :created, location: @cli_aprobacion }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cli_aprobacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cli_aprobaciones/1 or /cli_aprobaciones/1.json
  def update
    respond_to do |format|
      if @cli_aprobacion.update(cli_aprobacion_params)
        format.html { redirect_to @cli_aprobacion, notice: "Cli aprobacion was successfully updated." }
        format.json { render :show, status: :ok, location: @cli_aprobacion }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cli_aprobacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cli_aprobaciones/1 or /cli_aprobaciones/1.json
  def destroy
    @cli_aprobacion.destroy!

    respond_to do |format|
      format.html { redirect_to cli_aprobaciones_path, status: :see_other, notice: "Cli aprobacion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cli_aprobacion
      @cli_aprobacion = CliAprobacion.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def cli_aprobacion_params
      params.expect(cli_aprobacion: [ :fecha ])
    end
end
