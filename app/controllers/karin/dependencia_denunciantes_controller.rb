class Karin::DependenciaDenunciantesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_dependencia_denunciante, only: %i[ show edit update destroy ]

  # GET /dependencia_denunciantes or /dependencia_denunciantes.json
  def index
    @coleccion = DependenciaDenunciante.all
  end

  # GET /dependencia_denunciantes/1 or /dependencia_denunciantes/1.json
  def show
  end

  # GET /dependencia_denunciantes/new
  def new
    @objeto = DependenciaDenunciante.new
  end

  # GET /dependencia_denunciantes/1/edit
  def edit
  end

  # POST /dependencia_denunciantes or /dependencia_denunciantes.json
  def create
    @objeto = DependenciaDenunciante.new(dependencia_denunciante_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Dependencia del denunciante fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dependencia_denunciantes/1 or /dependencia_denunciantes/1.json
  def update
    respond_to do |format|
      if @objeto.update(dependencia_denunciante_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Dependencia del denunciante fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dependencia_denunciantes/1 or /dependencia_denunciantes/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Dependencia del denunciante fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dependencia_denunciante
      @objeto = DependenciaDenunciante.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = '/tablas/archivos_denuncia'
    end

    # Only allow a list of trusted parameters through.
    def dependencia_denunciante_params
      params.require(:dependencia_denunciante).permit(:dependencia_denunciante)
    end
end
