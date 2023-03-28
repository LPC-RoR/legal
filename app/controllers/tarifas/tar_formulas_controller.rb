class Tarifas::TarFormulasController < ApplicationController
  before_action :set_tar_formula, only: %i[ show edit update destroy ]

  # GET /tar_formulas or /tar_formulas.json
  def index
    @coleccion = TarFormula.all
  end

  # GET /tar_formulas/1 or /tar_formulas/1.json
  def show
  end

  # GET /tar_formulas/new
  def new
    @objeto = TarFormula.new(tar_tarifa_id: params[:tar_tarifa_id])
  end

  # GET /tar_formulas/1/edit
  def edit
  end

  # POST /tar_formulas or /tar_formulas.json
  def create
    @objeto = TarFormula.new(tar_formula_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar formula was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tar_formulas/1 or /tar_formulas/1.json
  def update
    respond_to do |format|
      if @objeto.update(tar_formula_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tar formula was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tar_formulas/1 or /tar_formulas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tar formula was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tar_formula
      @objeto = TarFormula.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.tar_tarifa
    end

    # Only allow a list of trusted parameters through.
    def tar_formula_params
      params.require(:tar_formula).permit(:orden, :codigo, :tar_tarifa_id, :tar_formula, :mensaje, :error)
    end
end
