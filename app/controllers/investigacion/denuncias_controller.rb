class Investigacion::DenunciasController < ApplicationController
  before_action :set_denuncia, only: %i[ show edit update destroy ]

  # GET /denuncias or /denuncias.json
  def index
    @coleccion = Denuncia.all
  end

  # GET /denuncias/1 or /denuncias/1.json
  def show
  end

  # GET /denuncias/new
  def new
    @objeto = Denuncia.new
  end

  # GET /denuncias/1/edit
  def edit
  end

  # POST /denuncias or /denuncias.json
  def create
    @objeto = Denuncia.new(denuncia_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to denuncia_url(@objeto), notice: "Denuncia fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /denuncias/1 or /denuncias/1.json
  def update
    respond_to do |format|
      if @objeto.update(denuncia_params)
        format.html { redirect_to denuncia_url(@objeto), notice: "Denuncia fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /denuncias/1 or /denuncias/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to denuncias_url, notice: "Denuncia fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_denuncia
      @objeto = Denuncia.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def denuncia_params
      params.require(:denuncia).permit(:empresa_id, :tipo_denuncia_id, :denunciante, :rut, :cargo, :lugar_trabajo, :verbal_escrita, :empleador_dt_tercero, :presencial_electronica, :email)
    end
end
