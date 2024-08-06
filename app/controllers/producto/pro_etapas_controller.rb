class Producto::ProEtapasController < ApplicationController
  before_action :set_pro_etapa, only: %i[ show edit update destroy ]

  # GET /pro_etapas or /pro_etapas.json
  def index
    @coleccion = ProEtapa.all
  end

  # GET /pro_etapas/1 or /pro_etapas/1.json
  def show
  end

  # GET /pro_etapas/new
  def new
    @objeto = ProEtapa.new
  end

  # GET /pro_etapas/1/edit
  def edit
  end

  # POST /pro_etapas or /pro_etapas.json
  def create
    @objeto = ProEtapa.new(pro_etapa_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to pro_etapa_url(@objeto), notice: "Pro etapa was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pro_etapas/1 or /pro_etapas/1.json
  def update
    respond_to do |format|
      if @objeto.update(pro_etapa_params)
        format.html { redirect_to pro_etapa_url(@objeto), notice: "Pro etapa was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pro_etapas/1 or /pro_etapas/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to pro_etapas_url, notice: "Pro etapa was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pro_etapa
      @objeto = ProEtapa.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pro_etapa_params
      params.require(:pro_etapa).permit(:producto_id, :orden, :code_descripcion, :pro_etapa, :estado)
    end
end
