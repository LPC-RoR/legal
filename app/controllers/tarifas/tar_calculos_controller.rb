class Tarifas::TarCalculosController < ApplicationController
  before_action :set_tar_calculo, only: %i[ show edit update destroy elimina_calculo liberar_calculo crea_aprobacion ]

  # GET /tar_calculos or /tar_calculos.json
  def index
    @coleccion = TarCalculo.all
  end

  # GET /tar_calculos/1 or /tar_calculos/1.json
  def show
  end

  # GET /tar_calculos/new
  def new
    @objeto = TarCalculo.new
  end

  # GET /tar_calculos/1/edit
  def edit
  end

  # POST /tar_calculos or /tar_calculos.json
  def create
    @objeto = TarCalculo.new(tar_calculo_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Tar calculo was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_calculos/1 or /tar_calculos/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_calculo_params)
        format.html { redirect_to @objeto, notice: "Tar calculo was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def elimina_calculo
    causa = @objeto.ownr
    @objeto.tar_facturaciones.each do |fctn|
      fctn.delete
    end
    @objeto.delete

    if causa.tar_facturaciones.count == causa.tar_tarifa.tar_pagos.count
      causa.estado = 'terminada'
    else
      causa.estado = 'tramitación'
    end
    causa.save

    redirect_to "/causas/#{causa.id}?html_options[menu]=Tarifa+%26+Pagos"
  end

  def crea_aprobacion
    cliente = @objeto.owner.cliente
    # crea aprobacion
    aprobacion = cliente.tar_aprobaciones.create(cliente_id: cliente.id, fecha: Time.zone.today.to_date)
    aprobacion.tar_calculos << @objeto
    # asocia todas las facturaciones del cliente disponibles
    disponibles = TarCalculo.where(tar_aprobacion_id: nil)
    disponibles.each do |ccl|
      aprobacion.tar_calculos << ccl if ccl.owner.cliente.id == cliente.id
    end

    redirect_to "/causas/#{@objeto.owner.id}?html_options[menu]=Tarifa+%26+Pagos"
  end

  def liberar_calculo
    causa = @objeto.owner
    @objeto.tar_aprobacion_id = nil
    @objeto.save

    redirect_to tar_aprobaciones_path
  end

  # DELETE /tar_calculos/1 or /tar_calculos/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to tar_calculos_url, notice: "Tar calculo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_calculo
      @objeto = TarCalculo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tar_calculo_params
      params.require(:tar_calculo).permit(:clnt_id, :ownr_clss, :ownr_id, :tar_pago_id, :moneda, :monto, :glosa, :cuantia)
    end
end
