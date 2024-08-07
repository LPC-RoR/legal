class Investigacion::TipoDenunciasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_tipo_denuncia, only: %i[ show edit update destroy ]

  # GET /tipo_denuncias or /tipo_denuncias.json
  def index
    @coleccion = TipoDenuncia.all
  end

  # GET /tipo_denuncias/1 or /tipo_denuncias/1.json
  def show
  end

  # GET /tipo_denuncias/new
  def new
    @objeto = TipoDenuncia.new
  end

  # GET /tipo_denuncias/1/edit
  def edit
  end

  # POST /tipo_denuncias or /tipo_denuncias.json
  def create
    @objeto = TipoDenuncia.new(tipo_denuncia_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Tipo de denuncia fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipo_denuncias/1 or /tipo_denuncias/1.json
  def update
    respond_to do |format|
      if @objeto.update(tipo_denuncia_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Tipo de denuncia fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_denuncias/1 or /tipo_denuncias/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Tipo de denuncia fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipo_denuncia
      @objeto = TipoDenuncia.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = '/tablas/tipos_investigacion'
    end

    # Only allow a list of trusted parameters through.
    def tipo_denuncia_params
      params.require(:tipo_denuncia).permit(:tipo_denuncia)
    end
end
