class Dt::DtTablaMultasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_dt_tabla_multa, only: %i[ show edit update destroy ]

  # GET /dt_tabla_multas or /dt_tabla_multas.json
  def index
    set_tabla('dt_tabla_multas', DtTablaMulta.all.order(:dt_tabla_multa), false)
    set_tabla('dt_tramos', DtTramo.all.order(:orden), false)
  end

  # GET /dt_tabla_multas/1 or /dt_tabla_multas/1.json
  def show
    set_tabla('dt_multas', @objeto.dt_multas.order(:orden), false)
  end

  # GET /dt_tabla_multas/new
  def new
    @objeto = DtTablaMulta.new
  end

  # GET /dt_tabla_multas/1/edit
  def edit
  end

  # POST /dt_tabla_multas or /dt_tabla_multas.json
  def create
    @objeto = DtTablaMulta.new(dt_tabla_multa_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tabla de Multa fue exitosamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dt_tabla_multas/1 or /dt_tabla_multas/1.json
  def update
    respond_to do |format|
      if @objeto.update(dt_tabla_multa_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Tabla de Multa fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dt_tabla_multas/1 or /dt_tabla_multas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Tabla de Multa fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dt_tabla_multa
      @objeto = DtTablaMulta.find(params[:id])
    end

    def set_redireccion
      @redireccion = dt_materias_path
    end

    # Only allow a list of trusted parameters through.
    def dt_tabla_multa_params
      params.require(:dt_tabla_multa).permit(:dt_tabla_multa, :moneda, :p100_leve, :p100_grave, :p100_gravisima)
    end
end
