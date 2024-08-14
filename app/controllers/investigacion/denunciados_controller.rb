class Investigacion::DenunciadosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_denunciado, only: %i[ show edit update destroy ]

  # GET /denunciados or /denunciados.json
  def index
    @coleccion = Denunciado.all
  end

  # GET /denunciados/1 or /denunciados/1.json
  def show
  end

  # GET /denunciados/new
  def new
    denuncia = Denuncia.find(params[:did])
    @objeto = Denunciado.new(denuncia_id: denuncia.id)
  end

  # GET /denunciados/1/edit
  def edit
  end

  # POST /denunciados or /denunciados.json
  def create
    @objeto = Denunciado.new(denunciado_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Denunciado fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /denunciados/1 or /denunciados/1.json
  def update
    respond_to do |format|
      if @objeto.update(denunciado_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Denunciado fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /denunciados/1 or /denunciados/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Denunciado fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_denunciado
      @objeto = Denunciado.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = "/denuncias/#{@objeto.denuncia.id}?html_options[menu]=Denunciados"
    end

    # Only allow a list of trusted parameters through.
    def denunciado_params
      params.require(:denunciado).permit(:denuncia_id, :tipo_denunciado_id, :rut_empresa_denunciado, :empresa_denunciado, :denunciado, :vinculo, :rut, :cargo, :lugar_trabajo, :email)
    end
end
