class Tarifas::TarFacturacionesController < ApplicationController
  before_action :set_tar_facturacion, only: %i[ show edit update destroy elimina facturable ]

  include Tarifas

  # GET /tar_facturaciones or /tar_facturaciones.json
  def index
    @coleccion = TarFacturacion.all
  end

  # GET /tar_facturaciones/1 or /tar_facturaciones/1.json
  def show
  end

  # GET /tar_facturaciones/new
  def new
    @objeto = TarFacturacion.new
  end

  # Crea DETALLE DE FACTURA, que será heredado por un factura luego
  # 1.- El detalle puede pertenecer a una CAUSA/CONSULTORIA
  # owner = CAUSA/CONSULTORIA
  def crea_facturacion
    # owner : CAUSA | CONSULTORIA
    owner = params[:owner_class].constantize.find(params[:owner_id])

    if params[:owner_class] == 'RegReporte'
      # fACTURACION DEL REPORTE DE HORAS
      monto = owner.moneda_reporte == 'UF' ? 0 : owner.monto_reporte
      monto_uf = owner.moneda_reporte == 'UF' ? owner.monto_reporte : 0
      TarFacturacion.create(owner_class: owner.class.name, owner_id: owner.id, facturable: params[:facturable], glosa: params[:facturable], estado: 'ingreso', monto: monto, monto_uf: monto_uf )
    else
      # FACTURACION DE TARIFAS CON FORMULAS | VALORES
      # do_eval funciona para CAUSA/CONSULTORIA
      pago = owner.tar_tarifa.tar_pagos.find_by(codigo_formula: params[:facturable])
      formula = TarFormula.find_by(codigo: params[:facturable]).tar_formula
      libreria = owner.tar_tarifa.tar_formulas
      #----------------------------------------
      owner_class = owner.class.name
      moneda = (pago.moneda.blank? ? 'UF' : pago.moneda)
      glosa = "#{pago.tar_pago} : #{owner.identificador} #{owner.send(owner.class.name.downcase)}"
      monto = calcula( formula, libreria, owner) 
      unless monto == 0
        TarFacturacion.create(owner_class: owner_class, owner_id: owner.id, facturable: params[:facturable], glosa: glosa, estado: 'ingreso', moneda: moneda, monto: monto)
      end
    end

    redirect_to "/#{owner.class.name.tableize}/#{owner.id}?html_options[tab]=Facturación"
  end

  # GET /tar_facturaciones/1/edit
  def edit
  end

  # POST /tar_facturaciones or /tar_facturaciones.json
  def create
    @objeto = TarFacturacion.new(tar_facturacion_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Tar facturacion was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_facturaciones/1 or /tar_facturaciones/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_facturacion_params)
        format.html { redirect_to @objeto, notice: "Tar facturacion was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def facturable
    tar_factura = @objeto.tar_factura
    tar_factura.tar_facturaciones.delete(@objeto)

    if tar_factura.tar_facturaciones.empty?
      tar_factura.delete
      redirect_to tar_facturas_path
    else
      concepto = (tar_factura.tar_facturaciones.count == 1 ? tar_factura.tar_facturaciones.first.glosa : "Varios de cliente #{tar_factura.padre.razon_social}")
      tar_factura.concepto = concepto
      tar_factura.save
      redirect_to tar_factura
    end

  end

  # DELETE /tar_facturaciones/1 or /tar_facturaciones/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to tar_facturaciones_url, notice: "Tar facturacion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # Elimina TarFactura de CAUSA/REG_REPORTE
  def elimina
    owner = params[:class_name].constantize.find(params[:objeto_id])
    @objeto.delete

    redirect_to owner
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_facturacion
      @objeto = TarFacturacion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tar_facturacion_params
      params.require(:tar_facturacion).permit(:facturable, :glosa, :monto, :estado, :owner_class, :owner_id)
    end
end
