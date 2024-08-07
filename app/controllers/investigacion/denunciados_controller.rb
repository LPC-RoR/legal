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
    @objeto = Denunciado.new
  end

  # GET /denunciados/1/edit
  def edit
  end

  # POST /denunciados or /denunciados.json
  def create
    @objeto = Denunciado.new(denunciado_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to denunciado_url(@objeto), notice: "Denunciado fue exitósamente creado." }
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
        format.html { redirect_to denunciado_url(@objeto), notice: "Denunciado fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /denunciados/1 or /denunciados/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to denunciados_url, notice: "Denunciado fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_denunciado
      @objeto = Denunciado.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def denunciado_params
      params.require(:denunciado).permit(:denuncia_id, :tipo_denunciado_id, :denunciado, :vinculo, :rut, :cargo, :lugar_trabajo, :email)
    end
end
