class Srvcs::TipoAsesoriasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_tipo_asesoria, only: %i[ show edit update destroy ]

  # GET /tipo_asesorias or /tipo_asesorias.json
  def index
    @coleccion = TipoAsesoria.all
  end

  # GET /tipo_asesorias/1 or /tipo_asesorias/1.json
  def show
  end

  # GET /tipo_asesorias/new
  def new
    @objeto = TipoAsesoria.new
  end

  # GET /tipo_asesorias/1/edit
  def edit
  end

  # POST /tipo_asesorias or /tipo_asesorias.json
  def create
    @objeto = TipoAsesoria.new(tipo_asesoria_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tipo de asesoria fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipo_asesorias/1 or /tipo_asesorias/1.json
  def update
    respond_to do |format|
      if @objeto.update(tipo_asesoria_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tipo de asesoria fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_asesorias/1 or /tipo_asesorias/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tipo de asesoria fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipo_asesoria
      @objeto = TipoAsesoria.find(params[:id])
    end

    def set_redireccion
      @redireccion = tabla_path(@objeto)
    end

    # Only allow a list of trusted parameters through.
    def tipo_asesoria_params
      params.require(:tipo_asesoria).permit(:tipo_asesoria, :descripcion, :facturable, :documento, :archivos)
    end
end
