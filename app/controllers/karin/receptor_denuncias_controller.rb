class Karin::ReceptorDenunciasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_receptor_denuncia, only: %i[ show edit update destroy ]

  # GET /receptor_denuncias or /receptor_denuncias.json
  def index
    @coleccion = ReceptorDenuncia.all
  end

  # GET /receptor_denuncias/1 or /receptor_denuncias/1.json
  def show
  end

  # GET /receptor_denuncias/new
  def new
    @objeto = ReceptorDenuncia.new
  end

  # GET /receptor_denuncias/1/edit
  def edit
  end

  # POST /receptor_denuncias or /receptor_denuncias.json
  def create
    @objeto = ReceptorDenuncia.new(receptor_denuncia_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Receptor de denuncia fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /receptor_denuncias/1 or /receptor_denuncias/1.json
  def update
    respond_to do |format|
      if @objeto.update(receptor_denuncia_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Receptor de denuncia fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receptor_denuncias/1 or /receptor_denuncias/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Receptor de denuncia fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_receptor_denuncia
      @objeto = ReceptorDenuncia.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = '/tablas/archivos_denuncia'
    end

    # Only allow a list of trusted parameters through.
    def receptor_denuncia_params
      params.require(:receptor_denuncia).permit(:receptor_denuncia)
    end
end
