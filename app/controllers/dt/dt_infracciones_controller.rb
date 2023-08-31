class Dt::DtInfraccionesController < ApplicationController
  before_action :set_dt_infraccion, only: %i[ show edit update destroy ]

  # GET /dt_infracciones or /dt_infracciones.json
  def index
    @coleccion = DtInfraccion.all
  end

  # GET /dt_infracciones/1 or /dt_infracciones/1.json
  def show
  end

  # GET /dt_infracciones/new
  def new
    @objeto = DtInfraccion.new(dt_materia_id: params[:dt_materia_id])
  end

  # GET /dt_infracciones/1/edit
  def edit
  end

  # POST /dt_infracciones or /dt_infracciones.json
  def create
    @objeto = DtInfraccion.new(dt_infraccion_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Infracción fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dt_infracciones/1 or /dt_infracciones/1.json
  def update
    respond_to do |format|
      if @objeto.update(dt_infraccion_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Infracción fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dt_infracciones/1 or /dt_infracciones/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Infracción fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dt_infraccion
      @objeto = DtInfraccion.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.dt_materia
    end

    # Only allow a list of trusted parameters through.
    def dt_infraccion_params
      params.require(:dt_infraccion).permit(:codigo, :normas, :dt_infraccion, :tipificacion, :criterios, :dt_materia_id, :dt_tabla_multa_id)
    end
end
