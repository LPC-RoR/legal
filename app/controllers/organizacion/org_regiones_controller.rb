class Organizacion::OrgRegionesController < ApplicationController
  before_action :set_org_region, only: %i[ show edit update destroy ]

  # GET /org_regiones or /org_regiones.json
  def index
    @coleccion = OrgRegion.all
  end

  # GET /org_regiones/1 or /org_regiones/1.json
  def show
  end

  # GET /org_regiones/new
  def new
    @objeto = OrgRegion.new(cliente_id: params[:oid])
  end

  # GET /org_regiones/1/edit
  def edit
  end

  # POST /org_regiones or /org_regiones.json
  def create
    @objeto = OrgRegion.new(org_region_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Región fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /org_regiones/1 or /org_regiones/1.json
  def update
    respond_to do |format|
      if @objeto.update(org_region_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Región fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /org_regiones/1 or /org_regiones/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Región fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_org_region
      @objeto = OrgRegion.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/servicios/organizacion?oid=#{@objeto.cliente.id}"
    end

    # Only allow a list of trusted parameters through.
    def org_region_params
      params.require(:org_region).permit(:org_region, :orden, :cliente_id, :region_id)
    end
end
