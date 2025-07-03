class Organizacion::OrgSucursalesController < ApplicationController
  before_action :set_org_sucursal, only: %i[ show edit update destroy ]

  # GET /org_sucursales or /org_sucursales.json
  def index
    @coleccion = OrgSucursal.all
  end

  # GET /org_sucursales/1 or /org_sucursales/1.json
  def show
  end

  # GET /org_sucursales/new
  def new
    @objeto = OrgSucursal.new(org_region_id: params[:org_region_id])
  end

  # GET /org_sucursales/1/edit
  def edit
  end

  # POST /org_sucursales or /org_sucursales.json
  def create
    @objeto = OrgSucursal.new(org_sucursal_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Sucursal fue exitosamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /org_sucursales/1 or /org_sucursales/1.json
  def update
    respond_to do |format|
      if @objeto.update(org_sucursal_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Sucursal fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /org_sucursales/1 or /org_sucursales/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Sucursal fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_org_sucursal
      @objeto = OrgSucursal.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/servicios/organizacion?oid=#{@objeto.org_region.cliente.id}"
    end

    # Only allow a list of trusted parameters through.
    def org_sucursal_params
      params.require(:org_sucursal).permit(:org_sucursal, :direccion, :org_region_id)
    end
end
