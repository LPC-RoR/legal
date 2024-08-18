class Karin::MotivoDenunciasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_motivo_denuncia, only: %i[ show edit update destroy ]

  # GET /motivo_denuncias or /motivo_denuncias.json
  def index
    @coleccion = MotivoDenuncia.all
  end

  # GET /motivo_denuncias/1 or /motivo_denuncias/1.json
  def show
  end

  # GET /motivo_denuncias/new
  def new
    @objeto = MotivoDenuncia.new
  end

  # GET /motivo_denuncias/1/edit
  def edit
  end

  # POST /motivo_denuncias or /motivo_denuncias.json
  def create
    @objeto = MotivoDenuncia.new(motivo_denuncia_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Motivo de denuncia fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /motivo_denuncias/1 or /motivo_denuncias/1.json
  def update
    respond_to do |format|
      if @objeto.update(motivo_denuncia_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Motivo de denuncia fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /motivo_denuncias/1 or /motivo_denuncias/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Motivo de denuncia fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_motivo_denuncia
      @objeto = MotivoDenuncia.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = '/tablas/archivos_denuncia'
    end

    # Only allow a list of trusted parameters through.
    def motivo_denuncia_params
      params.require(:motivo_denuncia).permit(:motivo_denuncia)
    end
end
