class Tarifas::TarTarifasController < ApplicationController
  before_action :set_tar_tarifa, only: %i[ show edit update destroy asigna desasigna ]

#  include Bandejas

  # GET /tar_tarifas or /tar_tarifas.json
  def index
  end

  # GET /tar_tarifas/1 or /tar_tarifas/1.json
  def show
    set_tabla('tar_pagos', @objeto.tar_pagos.all.order(:orden), false)
    set_tabla('tar_formulas', @objeto.tar_formulas.all.order(:orden), false)
    set_tabla('tar_elementos', TarElemento.all.order(:elemento), false)
    set_tabla('tar_detalles', @objeto.tar_detalles.order(:orden), false)
  end

  # GET /tar_tarifas/new
  def new
    owner_class = (params[:class_name].blank? ? nil : params[:class_name])
    owner_id    = (params[:objeto_id].blank? ? nil : params[:objeto_id])
    @objeto = TarTarifa.new(owner_class: owner_class, owner_id: owner_id, estado: 'ingreso')
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
      objeto = Causa.find(params[:cid])
      @objeto.causas << objeto
    end

    redirect_to "/causas/#{objeto.id}?html_options[menu]=Tarifa+%26+Cuantía"

  end

  def desasigna
    # DesAsigna una tarifa a una CAUSA o COONSULTORÍA

    unless params[:cid].blank?
      objeto = Causa.find(params[:cid])
      @objeto.causas.delete(objeto)
    end

    redirect_to "/causas/#{objeto.id}?html_options[menu]=Tarifa+%26+Cuantía"

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
      @redireccion = @objeto.padre.blank? ? "/tablas?tb=#{tb_index('tarifas_generales')}" : "/clientes/#{@objeto.padre.id}?html_options[menu]=Tarifas"
    end

    # Only allow a list of trusted parameters through.
    def tar_tarifa_params
      params.require(:tar_tarifa).permit(:tarifa, :estado, :facturables, :owner_class, :owner_id, :moneda, :valor, :valor_hora)
    end
end
