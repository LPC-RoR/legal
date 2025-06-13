class Csc::MontoConciliacionesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_monto_conciliacion, only: %i[ show edit update destroy ]

  after_action :actualiza_monto, only: %i[ update create ]

  # GET /monto_conciliaciones or /monto_conciliaciones.json
  def index
    @coleccion = MontoConciliacion.all
  end

  # GET /monto_conciliaciones/1 or /monto_conciliaciones/1.json
  def show
  end

  # GET /monto_conciliaciones/new
  def new
    @objeto = MontoConciliacion.new(causa_id: params[:oid])
  end

  # GET /monto_conciliaciones/1/edit
  def edit
  end

  # POST /monto_conciliaciones or /monto_conciliaciones.json
  def create
    @objeto = MontoConciliacion.new(monto_conciliacion_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Monto fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /monto_conciliaciones/1 or /monto_conciliaciones/1.json
  def update
    respond_to do |format|
      if @objeto.update(monto_conciliacion_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Monto fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /monto_conciliaciones/1 or /monto_conciliaciones/1.json
  def destroy
    set_redireccion
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Monto fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private

    def actualiza_monto
      causa = @objeto.causa
      ultimo = causa.monto_conciliaciones.last
      if @objeto == ultimo
        causa.monto_pagado = @objeto.persisted? ? (['Acuerdo', 'Sentencia'].include?(@objeto.tipo) ? @objeto.monto : nil) : nil
        causa.save
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_monto_conciliacion
      @objeto = MontoConciliacion.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/causas/#{@objeto.causa.id}"
    end

    # Only allow a list of trusted parameters through.
    def monto_conciliacion_params
      params.require(:monto_conciliacion).permit(:causa_id, :tipo, :fecha, :monto)
    end
end
