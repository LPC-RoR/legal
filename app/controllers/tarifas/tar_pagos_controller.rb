class Tarifas::TarPagosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_tar_pago, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: :destroy

  # GET /tar_pagos or /tar_pagos.json
  def index
  end

  # GET /tar_pagos/1 or /tar_pagos/1.json
  def show
    set_tabla('tar_comentarios', @objeto.tar_comentarios.order(:orden), false)
    set_tabla('tar_cuotas', @objeto.tar_cuotas.order(:orden), false)
  end

  # GET /tar_pagos/new
  def new
    ownr = TarTarifa.find(params[:oid])
    @objeto = TarPago.new(tar_tarifa_id: ownr.id, estado: 'ingreso', orden: ownr.tar_pagos.count + 1)
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
        format.html { redirect_to @redireccion, notice: "Pago fue exitosamente creado." }
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
        format.html { redirect_to @redireccion, notice: "Pago fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def arriba
    owner = @objeto.owner
    anterior = @objeto.anterior
    @objeto.orden -= 1
    @objeto.save
    anterior.orden += 1
    anterior.save

    redirect_to @objeto.redireccion
  end

  def abajo
    owner = @objeto.owner
    siguiente = @objeto.siguiente
    @objeto.orden += 1
    @objeto.save
    siguiente.orden -= 1
    siguiente.save

    redirect_to @objeto.redireccion
  end

  def reordenar
    @objeto.list.each_with_index do |val, index|
      unless val.orden == index + 1
        val.orden = index + 1
        val.save
      end
    end
  end

  # DELETE /tar_pagos/1 or /tar_pagos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Pago fue exitosamente eliminado." }
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
      params.require(:tar_pago).permit(:tar_tarifa_id, :tar_pago, :estado, :moneda, :valor, :orden, :codigo_formula, :detalla_porcentaje_cuantia, :requiere_uf)
    end
end
