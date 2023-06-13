class Tarifas::TarUfFacturacionesController < ApplicationController
  before_action :set_tar_uf_facturacion, only: %i[ show edit update destroy ]

  # GET /tar_uf_facturaciones or /tar_uf_facturaciones.json
  def index
    @coleccion = TarUfFacturacion.all
  end

  # GET /tar_uf_facturaciones/1 or /tar_uf_facturaciones/1.json
  def show
  end

  # GET /tar_uf_facturaciones/new
  def new
    owner = params[:class_name].constantize.find(params[:objeto_id])
    if owner.class.name == 'Causa'
      pagos_tarifa = owner.tar_tarifa.tar_pagos.map {|pago| pago.tar_pago}
      pagos_causa = owner.uf_facturaciones.map {|uf_pago| uf_pago.pago }
      @pagos_disponibles = pagos_tarifa - pagos_causa
    end
    @objeto = TarUfFacturacion.new(owner_class: params[:class_name], owner_id: owner.id)
  end

  # GET /tar_uf_facturaciones/1/edit
  def edit
  end

  # POST /tar_uf_facturaciones or /tar_uf_facturaciones.json
  def create
    @objeto = TarUfFacturacion.new(tar_uf_facturacion_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar uf facturacion was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_uf_facturaciones/1 or /tar_uf_facturaciones/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_uf_facturacion_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar uf facturacion was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_uf_facturaciones/1 or /tar_uf_facturaciones/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tar uf facturacion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_uf_facturacion
      @objeto = TarUfFacturacion.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.owner
    end

    # Only allow a list of trusted parameters through.
    def tar_uf_facturacion_params
      params.require(:tar_uf_facturacion).permit(:owner_class, :owner_id, :pago, :fecha_uf)
    end
end
