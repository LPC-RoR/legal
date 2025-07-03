class Tarifas::TarFormulasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_tar_formula, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: :destroy

  # GET /tar_formulas or /tar_formulas.json
  def index
  end

  # GET /tar_formulas/1 or /tar_formulas/1.json
  def show
  end

  # GET /tar_formulas/new
  def new
    ownr = TarTarifa.find(params[:oid])
    @objeto = TarFormula.new(tar_tarifa_id: ownr.id, orden: ownr.tar_formulas.count + 1)
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
        format.html { redirect_to @redireccion, notice: "Fórmula fue exitosamente creada." }
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
        format.html { redirect_to @redireccion, notice: "Fórmula fue exitosamente actualizada." }
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

  # DELETE /tar_formulas/1 or /tar_formulas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Fórmula fue exitosamente eliminada." }
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
