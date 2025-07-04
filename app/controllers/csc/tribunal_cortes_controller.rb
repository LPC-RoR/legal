class Csc::TribunalCortesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_tribunal_corte, only: %i[ show edit update destroy ]

  # GET /tribunal_cortes or /tribunal_cortes.json
  def index
    set_tabla('tribunal_cortes', TribunalCorte.trbnl_ordr, false)
  end

  # GET /tribunal_cortes/1 or /tribunal_cortes/1.json
  def show
  end

  # GET /tribunal_cortes/new
  def new
    @objeto = TribunalCorte.new
  end

  # GET /tribunal_cortes/1/edit
  def edit
  end

  # POST /tribunal_cortes or /tribunal_cortes.json
  def create
    @objeto = TribunalCorte.new(tribunal_corte_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tribunal/Corte fue exitosamente creado." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tribunal_cortes/1 or /tribunal_cortes/1.json
  def update
    respond_to do |format|
      if @objeto.update(tribunal_corte_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tribunal/Corte fue exitosamente actualizado." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tribunal_cortes/1 or /tribunal_cortes/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tribunal/Corte fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tribunal_corte
      @objeto = TribunalCorte.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/tablas/tribunal_corte"
    end

    # Only allow a list of trusted parameters through.
    def tribunal_corte_params
      params.require(:tribunal_corte).permit(:tribunal_corte)
    end
end
