  class Organizacion::OrgAreasController < ApplicationController
  before_action :set_org_area, only: %i[ show edit update destroy nuevo_hijo ]

  # GET /org_areas or /org_areas.json
  def index
    @coleccion = OrgArea.all
  end

  # GET /org_areas/1 or /org_areas/1.json
  def show
  end

  # GET /org_areas/new
  def new
    unless params[:oid].blank?
      cliente = Cliente.find(params[:oid])
      @objeto = cliente.org_areas.new
    end
    unless params[:pid].blank?
      area_padre = OrgArea.find(params[:pid])
      @objeto = OrgArea.new
      area_padre.children << @objeto
    end
  end

  def nuevo_hijo
    unless params[:nuevo_hijo][:org_area].blank?
      check_org_area = @objeto.padre.children.find_by(org_area: params[:nuevo_hijo][:org_area].downcase)
      if check_org_area.blank?
        nueva = OrgArea.create(org_area: params[:nuevo_hijo][:org_area].downcase)

        @objeto.childrenv << nueva
      end
    end

    redirect_to "/servicios/organizacion?oid=#{@objeto.padre_cliente.id}"
  end

  # GET /org_areas/1/edit 
  def edit
  end

  # POST /org_areas or /org_areas.json
  def create
    @objeto = OrgArea.new(org_area_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Área fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /org_areas/1 or /org_areas/1.json
  def update
    respond_to do |format|
      if @objeto.update(org_area_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Área fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /org_areas/1 or /org_areas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Área fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_org_area
      @objeto = OrgArea.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/servicios/organizacion?oid=#{@objeto.padre_cliente.id}"
    end

    # Only allow a list of trusted parameters through.
    def org_area_params
      params.require(:org_area).permit(:org_area, :cliente_id)
    end
end
