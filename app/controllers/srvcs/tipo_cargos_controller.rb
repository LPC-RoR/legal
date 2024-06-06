class Srvcs::TipoCargosController < ApplicationController
  before_action :set_tipo_cargo, only: %i[ show edit update destroy ]

  # GET /tipo_cargos or /tipo_cargos.json
  def index
    @coleccion = TipoCargo.all
  end

  # GET /tipo_cargos/1 or /tipo_cargos/1.json
  def show
  end

  # GET /tipo_cargos/new
  def new
    @objeto = TipoCargo.new
  end

  # GET /tipo_cargos/1/edit
  def edit
  end

  # POST /tipo_cargos or /tipo_cargos.json
  def create
    @objeto = TipoCargo.new(tipo_cargo_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tipo cargo was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipo_cargos/1 or /tipo_cargos/1.json
  def update
    respond_to do |format|
      if @objeto.update(tipo_cargo_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tipo cargo was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_cargos/1 or /tipo_cargos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tipo cargo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipo_cargo
      @objeto = TipoCargo.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/tablas/tipos"
    end

    # Only allow a list of trusted parameters through.
    def tipo_cargo_params
      params.require(:tipo_cargo).permit(:tipo_cargo)
    end
end
