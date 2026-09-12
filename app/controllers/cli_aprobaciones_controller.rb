class CliAprobacionesController < ApplicationController
  before_action :set_cli_aprobacion, only: %i[ show edit update destroy liberar_pagos generar_aprobacion ]

  include PdfGeneratable

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

  # Para conciliacion con DocEmitidos
  def search
    response.headers["Cache-Control"] = "no-store"   # ← no cachear búsquedas Ajax
    @aprobaciones = CliAprobacion
      .where(cliente_id: params[:cliente_id])
      .includes(:doc_emitidos)
      .order(fecha: :desc, id: :desc)   # ← mismo día: gana el id mayor (más reciente)
      .limit(20)

    # Si el usuario escribe algo, filtra por fecha (texto) o id
    if params[:q].present?
      @aprobaciones = @aprobaciones.where(
        "CAST(cli_aprobaciones.id AS TEXT) LIKE ? OR TO_CHAR(fecha, 'DD-MM-YYYY') LIKE ?",
        "%#{params[:q]}%", "%#{params[:q]}%"
      )
    end

    render json: @aprobaciones.map { |a| { id: a.id, text: "Aprobación ##{a.id} · #{a.fecha.strftime('%d-%m-%Y')} · #{a.doc_emitidos.size} docs" } }
  end

  def liberar_pagos
    @objeto.tar_facturaciones.each do |pago|
      pago.cli_aprobacion_id = nil
      pago.save
    end

    redirect_to @objeto.cliente
  end

  def generar_aprobacion
    # ownr: el cliente es el propietario polimórfico del ActArchivo
    # ownr cambiado a CliAprobacion
    generar_pdf('aprobacion',
      ownr: @objeto,
      objeto_id: @objeto.id,
      enviar_email: false
    )
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
      params.expect(cli_aprobacion: [ :fecha, tar_facturaciones_attributes: [:id, :glosa, :monto, :_destroy]])
    end
end
