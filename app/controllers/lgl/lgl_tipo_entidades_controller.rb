class Lgl::LglTipoEntidadesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_lgl_tipo_entidad, only: %i[ show edit update destroy ]

  # GET /lgl_tipo_entidades or /lgl_tipo_entidades.json
  def index
    @coleccion = LglTipoEntidad.all
  end

  # GET /lgl_tipo_entidades/1 or /lgl_tipo_entidades/1.json
  def show
  end

  # GET /lgl_tipo_entidades/new
  def new
    @objeto = LglTipoEntidad.new
  end

  # GET /lgl_tipo_entidades/1/edit
  def edit
  end

  # POST /lgl_tipo_entidades or /lgl_tipo_entidades.json
  def create
    @objeto = LglTipoEntidad.new(lgl_tipo_entidad_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Tipo de entidad fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lgl_tipo_entidades/1 or /lgl_tipo_entidades/1.json
  def update
    respond_to do |format|
      if @objeto.update(lgl_tipo_entidad_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Tipo de entidad fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lgl_tipo_entidades/1 or /lgl_tipo_entidades/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Tipo de entidad fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lgl_tipo_entidad
      @objeto = LglTipoEntidad.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = lgl_documentos_path
    end

    # Only allow a list of trusted parameters through.
    def lgl_tipo_entidad_params
      params.require(:lgl_tipo_entidad).permit(:lgl_tipo_entidad)
    end
end
