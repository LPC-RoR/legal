class TribunalCortesController < ApplicationController
  before_action :set_tribunal_corte, only: %i[ show edit update destroy ]

  # GET /tribunal_cortes or /tribunal_cortes.json
  def index
    @coleccion = TribunalCorte.all
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
        format.html { redirect_to @redireccion, notice: "Tribunal/Corte fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tribunal_cortes/1 or /tribunal_cortes/1.json
  def update
    respond_to do |format|
      if @objeto.update(tribunal_corte_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tribunal/Corte fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tribunal_cortes/1 or /tribunal_cortes/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tribunal/Corte fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tribunal_corte
      @objeto = TribunalCorte.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/tablas/cuantias_tribunales"
    end

    # Only allow a list of trusted parameters through.
    def tribunal_corte_params
      params.require(:tribunal_corte).permit(:tribunal_corte)
    end
end
