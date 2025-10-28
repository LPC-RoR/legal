class Tarifas::TarTarifasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_tar_tarifa, only: %i[ show edit update destroy asigna ]

  layout 'addt'

  # GET /tar_tarifas or /tar_tarifas.json
  def index
  end

  # GET /tar_tarifas/1 or /tar_tarifas/1.json
  def show
    set_tabla('tar_pagos', @objeto.tar_pagos.order(:orden), false)
    set_tabla('tar_formulas', @objeto.tar_formulas.order(:orden), false)

    set_tabla('tar_formula_cuantias', @objeto.tar_formula_cuantias, false)
    set_tabla('tar_tipo_variables', @objeto.tar_tipo_variables, false)
  end

  # GET /tar_tarifas/new
  def new
    @objeto = TarTarifa.new(ownr_type: params[:oclss], ownr_id: params[:oid], estado: 'ingreso')
  end

  # GET /tar_tarifas/1/edit
  def edit
  end

  # POST /tar_tarifas or /tar_tarifas.json
  def create
    @objeto = TarTarifa.new(tar_tarifa_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tarifa fue exitosamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_tarifas/1 or /tar_tarifas/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_tarifa_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tarifa fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def asigna
    # Asigna una tarifa a una CAUSA o CONSULTORÍA

    unless params[:cid].blank?
      causa = Causa.find(params[:cid])
      @objeto.causas << causa
    end

    redirect_to "/causas/#{params[:cid]}?html_options[menu]=Tarifa+%26+Pagos"

  end

  # DELETE /tar_tarifas/1 or /tar_tarifas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tarifa fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_tarifa
      @objeto = TarTarifa.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.ownr_id.blank? ? tabla_path(@objeto) : "/clientes/#{@objeto.ownr_id}?html_options[menu]=Tarifas"
    end

    # Only allow a list of trusted parameters through.
    def tar_tarifa_params
      params.require(:tar_tarifa).permit(:tarifa, :estado, :facturables, :ownr_type, :ownr_id, :moneda, :valor, :valor_hora, :cuantia_tarifa, :tipo_causa_id, :code_causa)
    end
end
