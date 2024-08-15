class Lgl::LglNEmpleadosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_lgl_n_empleado, only: %i[ show edit update destroy ]

  # GET /lgl_n_empleados or /lgl_n_empleados.json
  def index
    @coleccion = LglNEmpleado.all
  end

  # GET /lgl_n_empleados/1 or /lgl_n_empleados/1.json
  def show
  end

  # GET /lgl_n_empleados/new
  def new
    @objeto = LglNEmpleado.new
  end

  # GET /lgl_n_empleados/1/edit
  def edit
  end

  # POST /lgl_n_empleados or /lgl_n_empleados.json
  def create
    @objeto = LglNEmpleado.new(lgl_n_empleado_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Número de empleados ha sido exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lgl_n_empleados/1 or /lgl_n_empleados/1.json
  def update
    respond_to do |format|
      if @objeto.update(lgl_n_empleado_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Número de empleados ha sido exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lgl_n_empleados/1 or /lgl_n_empleados/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Número de empleados ha sido exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lgl_n_empleado
      @objeto = LglNEmpleado.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = lgl_documentos_path
    end

    # Only allow a list of trusted parameters through.
    def lgl_n_empleado_params
      params.require(:lgl_n_empleado).permit(:lgl_n_empleados, :n_min, :n_max)
    end
end
