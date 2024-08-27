class Karin::KrnEmpleadosController < ApplicationController
  before_action :set_krn_empleado, only: %i[ show edit update destroy ]

  # GET /krn_empleados or /krn_empleados.json
  def index
    @coleccion = KrnEmpleado.all
  end

  # GET /krn_empleados/1 or /krn_empleados/1.json
  def show
  end

  # GET /krn_empleados/new
  def new
    @objeto = KrnEmpleado.new
  end

  # GET /krn_empleados/1/edit
  def edit
  end

  # POST /krn_empleados or /krn_empleados.json
  def create
    @objeto = KrnEmpleado.new(krn_empleado_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Empleado fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_empleados/1 or /krn_empleados/1.json
  def update
    respond_to do |format|
      if @objeto.update(krn_empleado_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Empleado fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_empleados/1 or /krn_empleados/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Empleado fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_empleado
      @objeto = KrnEmpleado.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = krn_empleados_path
    end

    # Only allow a list of trusted parameters through.
    def krn_empleado_params
      params.require(:krn_empleado).permit(:cliente_id, :empresa_id, :rut, :nombre)
    end
end
