class Tarifas::TarTipoVariablesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_objeto, only: %i[ show edit update destroy ]

  # GET /@coleccion or /@coleccion.json
  def index
    @coleccion = TarTipoVariable.all
  end

  # GET /@coleccion/1 or /@coleccion/1.json
  def show
  end

  # GET /@coleccion/new
  def new
    @objeto = TarTipoVariable.new(tar_tarifa_id: params[:oid])
  end

  # GET /@coleccion/1/edit
  def edit
  end

  # POST /@coleccion or /@coleccion.json
  def create
    @objeto = TarTipoVariable.new(objeto_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Porcentaje variable del tipo de causa exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /@coleccion/1 or /@coleccion/1.json
  def update
    respond_to do |format|
      if @objeto.update(objeto_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Porcentaje variable del tipo de causa exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /@coleccion/1 or /@coleccion/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Porcentaje variable del tipo de causa exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_objeto
      @objeto = TarTipoVariable.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = @objeto.tar_tarifa
    end

    # Only allow a list of trusted parameters through.
    def objeto_params
      params.require(:tar_tipo_variable).permit(:tar_tarifa_id, :tipo_causa_id, :variable_tipo_causa)
    end
end
