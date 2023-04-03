class Tarifas::TarPagosController < ApplicationController
  before_action :set_tar_pago, only: %i[ show edit update destroy ]

  # GET /tar_pagos or /tar_pagos.json
  def index
  end

  # GET /tar_pagos/1 or /tar_pagos/1.json
  def show
#    @coleccion = {}
#    @coleccion['tar_comentarios'] = @objeto.tar_comentarios.order(:orden)
    init_tabla('tar_comentarios', @objeto.tar_comentarios.order(:orden), false)
  end

  # GET /tar_pagos/new
  def new
    @objeto = TarPago.new(tar_tarifa_id: params[:tar_tarifa_id], estado: 'ingreso')
  end

  # GET /tar_pagos/1/edit
  def edit
  end

  # POST /tar_pagos or /tar_pagos.json
  def create
    @objeto = TarPago.new(tar_pago_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar pago was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_pagos/1 or /tar_pagos/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_pago_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar pago was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_pagos/1 or /tar_pagos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tar pago was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_pago
      @objeto = TarPago.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.tar_tarifa
    end

    # Only allow a list of trusted parameters through.
    def tar_pago_params
      params.require(:tar_pago).permit(:tar_tarifa_id, :tar_pago, :estado, :moneda, :valor, :orden, :codigo_formula)
    end
end
