class Lgl::LglEntidadesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_lgl_entidad, only: %i[ show edit update destroy ]

  # GET /lgl_entidades or /lgl_entidades.json
  def index
    @coleccion = LglEntidad.all
  end

  # GET /lgl_entidades/1 or /lgl_entidades/1.json
  def show
  end

  # GET /lgl_entidades/new
  def new
    @objeto = LglEntidad.new
  end

  # GET /lgl_entidades/1/edit
  def edit
  end

  # POST /lgl_entidades or /lgl_entidades.json
  def create
    @objeto = LglEntidad.new(lgl_entidad_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to lgl_entidad_url(@objeto), notice: "Lgl entidad was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lgl_entidades/1 or /lgl_entidades/1.json
  def update
    respond_to do |format|
      if @objeto.update(lgl_entidad_params)
        format.html { redirect_to lgl_entidad_url(@objeto), notice: "Lgl entidad was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lgl_entidades/1 or /lgl_entidades/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to lgl_entidades_url, notice: "Lgl entidad was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lgl_entidad
      @objeto = LglEntidad.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lgl_entidad_params
      params.require(:lgl_entidad).permit(:lgl_entidad, :tipo, :dependencia)
    end
end
