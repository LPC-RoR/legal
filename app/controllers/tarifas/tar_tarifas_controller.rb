class Tarifas::TarTarifasController < ApplicationController
  before_action :set_tar_tarifa, only: %i[ show edit update destroy asigna ]

#  include Bandejas

  # GET /tar_tarifas or /tar_tarifas.json
  def index
  end

  # GET /tar_tarifas/1 or /tar_tarifas/1.json
  def show
    set_tabla('tar_pagos', @objeto.tar_pagos.order(:orden), false)
    set_tabla('tar_formulas', @objeto.tar_formulas.order(:orden), false)

    set_tabla('tar_formula_cuantias', @objeto.tar_formula_cuantias, false)
    set_tabla('tar_variable_bases', @objeto.tar_variable_bases, false)

    set_tabla('tar_elementos', TarElemento.order(:elemento), false)
    set_tabla('tar_detalles', @objeto.tar_detalles.order(:orden), false)
  end

  # GET /tar_tarifas/new
  def new
    ownr_clss = params[:ownr_clss] == '' ? nil : params[:ownr_clss]
    ownr_id = params[:ownr_id]
    @objeto = TarTarifa.new(owner_class: ownr_clss, owner_id: ownr_id, estado: 'ingreso')
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
        format.html { redirect_to @redireccion, notice: "Tarifa fue exitósamente creada." }
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
        format.html { redirect_to @redireccion, notice: "Tarifa fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def asigna
    # Asigna una tarifa a una CAUSA o COONSULTORÍA

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
      format.html { redirect_to @redireccion, notice: "Tarifa fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_tarifa
      @objeto = TarTarifa.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.owner_class.blank? ? tabla_path(@objeto) : "/clientes/#{@objeto.owner_id}?html_options[menu]=Tarifas"
    end

    # Only allow a list of trusted parameters through.
    def tar_tarifa_params
      params.require(:tar_tarifa).permit(:tarifa, :estado, :facturables, :owner_class, :owner_id, :moneda, :valor, :valor_hora, :cuantia_tarifa, :tipo_causa_id)
    end
end
