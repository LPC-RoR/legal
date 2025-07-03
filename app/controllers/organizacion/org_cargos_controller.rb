class Organizacion::OrgCargosController < ApplicationController
  before_action :set_org_cargo, only: %i[ show edit update destroy ]

  # GET /org_cargos or /org_cargos.json
  def index
    @coleccion = OrgCargo.all
  end

  # GET /org_cargos/1 or /org_cargos/1.json
  def show
  end

  # GET /org_cargos/new
  def new
    unless params[:aid].blank?
      area = OrgArea.find(params[:aid])
      @objeto = area.org_cargos.new
    end
  end

  def nuevo
    area = OrgArea.find(params[:pid])
    unless area.blank?
      unless params[:nuevo_cargo][:org_cargo].blank?
        cargo = area.org_cargos.create(org_cargo: params[:nuevo_cargo][:org_cargo], dotacion: params[:nuevo_cargo][:dotacion])
      end
    end

    redirect_to "/servicios/organizacion?oid=#{area.padre_cliente.id}"
  end

  # GET /org_cargos/1/edit
  def edit
  end

  # POST /org_cargos or /org_cargos.json
  def create
    @objeto = OrgCargo.new(org_cargo_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Cargo fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /org_cargos/1 or /org_cargos/1.json
  def update
    respond_to do |format|
      if @objeto.update(org_cargo_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Cargo fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /org_cargos/1 or /org_cargos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Cargo fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_org_cargo
      @objeto = OrgCargo.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/servicios/organizacion?oid=#{@objeto.padre_cliente.id}"
    end

    # Only allow a list of trusted parameters through.
    def org_cargo_params
      params.require(:org_cargo).permit(:org_cargo, :dotacion, :org_area_id)
    end
end
