class Investigacion::TipoDenunciadosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_tipo_denunciado, only: %i[ show edit update destroy ]

  # GET /tipo_denunciados or /tipo_denunciados.json
  def index
    @coleccion = TipoDenunciado.all
  end

  # GET /tipo_denunciados/1 or /tipo_denunciados/1.json
  def show
  end

  # GET /tipo_denunciados/new
  def new
    @objeto = TipoDenunciado.new
  end

  # GET /tipo_denunciados/1/edit
  def edit
  end

  # POST /tipo_denunciados or /tipo_denunciados.json
  def create
    @objeto = TipoDenunciado.new(tipo_denunciado_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Tipo de denunciado fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipo_denunciados/1 or /tipo_denunciados/1.json
  def update
    respond_to do |format|
      if @objeto.update(tipo_denunciado_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Tipo de denunciado fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_denunciados/1 or /tipo_denunciados/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Tipo de denunciado fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipo_denunciado
      @objeto = TipoDenunciado.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = '/tablas/general'
    end

    # Only allow a list of trusted parameters through.
    def tipo_denunciado_params
      params.require(:tipo_denunciado).permit(:tipo_denunciado)
    end
end
