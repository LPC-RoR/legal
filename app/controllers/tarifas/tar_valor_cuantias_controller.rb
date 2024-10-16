class Tarifas::TarValorCuantiasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_tar_valor_cuantia, only: %i[ show edit update destroy ]

  # GET /tar_valor_cuantias or /tar_valor_cuantias.json
  def index
  end

  # GET /tar_valor_cuantias/1 or /tar_valor_cuantias/1.json
  def show
  end

  # GET /tar_valor_cuantias/new
  def new
    @objeto = TarValorCuantia.new(ownr_type: params[:class_name], ownr_id: params[:objeto_id])
  end

  # GET /tar_valor_cuantias/1/edit
  def edit
  end

  # POST /tar_valor_cuantias or /tar_valor_cuantias.json
  def create
    @objeto = TarValorCuantia.new(tar_valor_cuantia_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Valor de Cuantía fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_valor_cuantias/1 or /tar_valor_cuantias/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_valor_cuantia_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Valor de Cuantía fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_valor_cuantias/1 or /tar_valor_cuantias/1.json
  def destroy
    @objeto.destroy
    set_redireccion
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Valor de Cuantía fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_valor_cuantia
      @objeto = TarValorCuantia.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/causas/#{@objeto.ownr.id}?html_options[menu]=#{CGI.escape('Datos & Cuantía')}"
    end

    # Only allow a list of trusted parameters through.
    def tar_valor_cuantia_params
      params.require(:tar_valor_cuantia).permit(:ownr_type, :ownr_id, :tar_detalle_cuantia_id, :otro_detalle, :valor, :valor_uf, :moneda, :valor_tarifa, :nota, :desactivado, :demandante_id)
    end
end
