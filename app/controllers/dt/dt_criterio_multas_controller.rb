class Dt::DtCriterioMultasController < ApplicationController
  before_action :set_dt_criterio_multa, only: %i[ show edit update destroy ]

  # GET /dt_criterio_multas or /dt_criterio_multas.json
  def index
    @coleccion = DtCriterioMulta.all
  end

  # GET /dt_criterio_multas/1 or /dt_criterio_multas/1.json
  def show
  end

  # GET /dt_criterio_multas/new
  def new
    @objeto = DtCriterioMulta.new(dt_tabla_multa_id: params[:dt_tabla_multa_id])
  end

  # GET /dt_criterio_multas/1/edit
  def edit
  end

  # POST /dt_criterio_multas or /dt_criterio_multas.json
  def create
    @objeto = DtCriterioMulta.new(dt_criterio_multa_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Criterio fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dt_criterio_multas/1 or /dt_criterio_multas/1.json
  def update
    respond_to do |format|
      if @objeto.update(dt_criterio_multa_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Criterio fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dt_criterio_multas/1 or /dt_criterio_multas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Criterio fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dt_criterio_multa
      @objeto = DtCriterioMulta.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.dt_tabla_multa
    end

    # Only allow a list of trusted parameters through.
    def dt_criterio_multa_params
      params.require(:dt_criterio_multa).permit(:dt_tabla_multa_id, :orden, :monto, :unidad, :dt_criterio_multa)
    end
end
