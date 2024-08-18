class Karin::AlcanceDenunciasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_alcance_denuncia, only: %i[ show edit update destroy ]

  # GET /alcance_denuncias or /alcance_denuncias.json
  def index
    @coleccion = AlcanceDenuncia.all
  end

  # GET /alcance_denuncias/1 or /alcance_denuncias/1.json
  def show
  end

  # GET /alcance_denuncias/new
  def new
    @objeto = AlcanceDenuncia.new
  end

  # GET /alcance_denuncias/1/edit
  def edit
  end

  # POST /alcance_denuncias or /alcance_denuncias.json
  def create
    @objeto = AlcanceDenuncia.new(alcance_denuncia_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Alcance de denuncia fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /alcance_denuncias/1 or /alcance_denuncias/1.json
  def update
    respond_to do |format|
      if @objeto.update(alcance_denuncia_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Alcance de denuncia fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alcance_denuncias/1 or /alcance_denuncias/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Alcance de denuncia fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alcance_denuncia
      @objeto = AlcanceDenuncia.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = '/tablas/archivos_denuncia'
    end

    # Only allow a list of trusted parameters through.
    def alcance_denuncia_params
      params.require(:alcance_denuncia).permit(:alcance_denuncia)
    end
end
