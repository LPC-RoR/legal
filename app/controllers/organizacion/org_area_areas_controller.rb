class Organizacion::OrgAreaAreasController < ApplicationController
  before_action :set_org_area_area, only: %i[ show edit update destroy ]

  # GET /org_area_areas or /org_area_areas.json
  def index
    @coleccion = OrgAreaArea.all
  end

  # GET /org_area_areas/1 or /org_area_areas/1.json
  def show
  end

  # GET /org_area_areas/new
  def new
    @objeto = OrgAreaArea.new
  end

  # GET /org_area_areas/1/edit
  def edit
  end

  # POST /org_area_areas or /org_area_areas.json
  def create
    @objeto = OrgAreaArea.new(org_area_area_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Org area area was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /org_area_areas/1 or /org_area_areas/1.json
  def update
    respond_to do |format|
      if @objeto.update(org_area_area_params)
        format.html { redirect_to @objeto, notice: "Org area area was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /org_area_areas/1 or /org_area_areas/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to org_area_areas_url, notice: "Org area area was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_org_area_area
      @objeto = OrgAreaArea.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def org_area_area_params
      params.require(:org_area_area).permit(:parent_id, :child_id)
    end
end
