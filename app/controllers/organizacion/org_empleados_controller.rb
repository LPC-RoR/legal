class Organizacion::OrgEmpleadosController < ApplicationController
  before_action :set_org_empleado, only: %i[ show edit update destroy ]
  after_action :rut_puro, only: %i[ create update ]

  # GET /org_empleados or /org_empleados.json
  def index
    @coleccion = OrgEmpleado.all
  end

  # GET /org_empleados/1 or /org_empleados/1.json
  def show
  end

  # GET /org_empleados/new
  def new
    unless params[:cid].blank?
      cargo = OrgCargo.find(params[:cid])
      @objeto = cargo.org_empleados.new
    end
  end

  # GET /org_empleados/1/edit
  def edit
  end

  # POST /org_empleados or /org_empleados.json
  def create
    @objeto = OrgEmpleado.new(org_empleado_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Org empleado was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /org_empleados/1 or /org_empleados/1.json
  def update
    respond_to do |format|
      if @objeto.update(org_empleado_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Org empleado was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /org_empleados/1 or /org_empleados/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Org empleado was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def rut_puro
      @objeto.rut = @objeto.rut.gsub(' ', '').gsub('.', '').gsub('-', '')
      @objeto.save
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_org_empleado
      @objeto = OrgEmpleado.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/servicios/organizacion?oid=#{@objeto.padre_cliente.id}"
    end

    # Only allow a list of trusted parameters through.
    def org_empleado_params
      params.require(:org_empleado).permit(:rut, :nombres, :apellido_paterno, :apellido_materno, :org_cargo_id, :fecha_nacimiento, :org_sucursal_id)
    end
end
