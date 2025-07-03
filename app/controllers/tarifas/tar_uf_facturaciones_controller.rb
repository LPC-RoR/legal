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
      @pagos_disponibles = owner.tar_tarifa.tar_pagos.map {|pago| pago.tar_pago}
    end
    @objeto = TarUfFacturacion.new(owner_class: params[:class_name], owner_id: owner.id)
  end

  # Llamado desde Causa / Asesoría indistintamente
  # oclss; oid
  def crea_uf_facturacion
    f_prms = params[:form_uf_facturacion]
    owner = params[:oclss].constantize.find(params[:oid])
    unless owner.blank?
      unless params[:form_tar_facturacion]['fecha_uf(1i)'].blank? or params[:form_tar_facturacion]['fecha_uf(2i)'].blank? or params[:form_tar_facturacion]['fecha_uf(3i)'].blank?
        tar_pago = TarPago.find(params[:pid])
        tar_pago_id = tar_pago.blank? ? nil : tar_pago.id

        unless tar_pago.blank? and params[:oclss] == 'Causa'
          tar_uf_facturacion = owner.class.name == 'Causa' ? owner.tar_uf_facturacion(tar_pago) : owner.uf_facturacion
          tar_uf_facturacion = TarUfFacturacion.create( owner_class: params[:oclss], owner_id: params[:oid], tar_pago_id: tar_pago_id ) if tar_uf_facturacion.blank?

          annio = params[:form_tar_facturacion]['fecha_uf(1i)'].to_i
          mes = params[:form_tar_facturacion]['fecha_uf(2i)'].to_i
          dia = params[:form_tar_facturacion]['fecha_uf(3i)'].to_i

          tar_uf_facturacion.fecha_uf = Time.zone.parse("#{annio}-#{mes}-#{dia}")
          tar_uf_facturacion.save
        end
      end
    end

    @objeto = owner
    get_rdrccn
    redirect_to @rdrccn, notice: "UF de facturación exitosamente creada"
  end

  # GET /tar_uf_facturaciones/1/edit
  def edit
    if @objeto.owner.class.name == 'Causa'
      pagos_tarifa = @objeto.owner.tar_tarifa.tar_pagos.map {|pago| pago.tar_pago}
      pagos_causa = @objeto.owner.uf_facturaciones.map {|uf_pago| uf_pago.pago }
      @pagos_disponibles = pagos_tarifa - pagos_causa
    end
  end

  # POST /tar_uf_facturaciones or /tar_uf_facturaciones.json
  def create
    @objeto = TarUfFacturacion.new(tar_uf_facturacion_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "UF fue exitosamente creada." }
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
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "UF fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_uf_facturaciones/1 or /tar_uf_facturaciones/1.json
  def destroy
    get_rdrccn
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "UF fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_uf_facturacion
      @objeto = TarUfFacturacion.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = @objeto.class.name == 'Causa' ? "/causas/#{@objeto.owner.id}?html_options[menu]=Pagos" : asesorias_path
    end

    # Only allow a list of trusted parameters through.
    def tar_uf_facturacion_params
      params.require(:tar_uf_facturacion).permit(:owner_class, :owner_id, :pago, :fecha_uf)
    end
end
