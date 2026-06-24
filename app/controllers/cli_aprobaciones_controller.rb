class CliAprobacionesController < ApplicationController
  before_action :set_cli_aprobacion, only: %i[ show edit update destroy liberar_pagos ]

  # GET /cli_aprobaciones or /cli_aprobaciones.json
  def index
    @clccn = CliAprobacion.all
  end

  # GET /cli_aprobaciones/1 or /cli_aprobaciones/1.json
  def show
  end

  # GET /cli_aprobaciones/new
  def new
    @objeto = CliAprobacion.new
  end

  # GET /cli_aprobaciones/1/edit
  def edit
  end

  # POST /cli_aprobaciones or /cli_aprobaciones.json
  def create
    @objeto = CliAprobacion.new(cli_aprobacion_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto.cliente, notice: "Aprobacion fue exitosamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cli_aprobaciones/1 or /cli_aprobaciones/1.json
  def update
    respond_to do |format|
      if @objeto.update(cli_aprobacion_params)
        format.html { redirect_to @objeto.cliente, notice: "Aprobacion fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def liberar_pagos
    @objeto.tar_facturaciones.each do |pago|
      pago.cli_aprobacion_id = nil
      pago.save
    end

    redirect_to @objeto.cliente
  end

  # DELETE /cli_aprobaciones/1 or /cli_aprobaciones/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @objeto.cliente, status: :see_other, notice: "Aprobacion fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cli_aprobacion
      @objeto = CliAprobacion.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def cli_aprobacion_params
      params.expect(cli_aprobacion: [ :fecha ])
    end
end
