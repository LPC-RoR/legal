class Tarifas::TarFormulaCuantiasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_tar_formula_cuantia, only: %i[ show edit update destroy ]

  # GET /tar_formula_cuantias or /tar_formula_cuantias.json
  def index
  end

  # GET /tar_formula_cuantias/1 or /tar_formula_cuantias/1.json
  def show
  end

  # GET /tar_formula_cuantias/new
  def new
    @objeto = TarFormulaCuantia.new(tar_tarifa_id: params[:oid])
  end

  # GET /tar_formula_cuantias/1/edit
  def edit
  end

  # POST /tar_formula_cuantias or /tar_formula_cuantias.json
  def create
    @objeto = TarFormulaCuantia.new(tar_formula_cuantia_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Fórmula de cuantia de tarifa ha sido exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_formula_cuantias/1 or /tar_formula_cuantias/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_formula_cuantia_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Fórmula de cuantia de tarifa ha sido exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_formula_cuantias/1 or /tar_formula_cuantias/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Fórmula de cuantia de tarifa ha sido exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_formula_cuantia
      @objeto = TarFormulaCuantia.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.tar_tarifa
    end

    # Only allow a list of trusted parameters through.
    def tar_formula_cuantia_params
      params.require(:tar_formula_cuantia).permit(:tar_tarifa_id, :tar_detalle_cuantia_id, :tar_formula_cuantia, :porcentaje_base)
    end
end
