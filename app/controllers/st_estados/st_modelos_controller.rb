class StEstados::StModelosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_st_modelo, only: %i[ show edit update destroy ]

  # GET /st_modelos or /st_modelos.json
  def index
    set_tabla('st_modelos', StModelo.ordr, false)
  end

  # GET /st_modelos/1 or /st_modelos/1.json
  def show
    set_tabla('st_estados', @objeto.st_estados.ordr, false)
    set_tabla('rep_doc_controlados', @objeto.rep_doc_controlados.ordr, false)
  end

  # GET /st_modelos/new
  def new
    @objeto = StModelo.new
  end

  # GET /st_modelos/1/edit
  def edit
  end

  # POST /st_modelos or /st_modelos.json
  def create
    @objeto = StModelo.new(st_modelo_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Modelo fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /st_modelos/1 or /st_modelos/1.json
  def update
    respond_to do |format|
      if @objeto.update(st_modelo_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Modelo fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /st_modelos/1 or /st_modelos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Modelo fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_st_modelo
      @objeto = StModelo.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/st_modelos" 
    end

    # Only allow a list of trusted parameters through.
    def st_modelo_params
      params.require(:st_modelo).permit(:st_modelo, :bandeja, :crud, :k_estados)
    end
end
