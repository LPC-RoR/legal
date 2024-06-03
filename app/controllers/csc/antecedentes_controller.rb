class Csc::AntecedentesController < ApplicationController
  before_action :set_antecedente, only: %i[ show edit update destroy ]

  # GET /antecedentes or /antecedentes.json
  def index
    @coleccion = Antecedente.all
  end

  # GET /antecedentes/1 or /antecedentes/1.json
  def show
  end

  # GET /antecedentes/new
  def new
    @objeto = Antecedente.new(causa_id: params[:causa_id])
  end

  # GET /antecedentes/1/edit
  def edit
  end

  # POST /antecedentes or /antecedentes.json
  def create
    @objeto = Antecedente.new(antecedente_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Antecedente fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /antecedentes/1 or /antecedentes/1.json
  def update
    respond_to do |format|
      if @objeto.update(antecedente_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Antecedente fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /antecedentes/1 or /antecedentes/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Antecedente fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_antecedente
      @objeto = Antecedente.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/causas/#{@objeto.causa.id}?html_options[menu]=Hechos"
    end

    # Only allow a list of trusted parameters through.
    def antecedente_params
      params.require(:antecedente).permit(:hecho, :riesgo, :ventaja, :cita, :orden, :causa_id)
    end
end
