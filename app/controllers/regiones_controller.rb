class RegionesController < ApplicationController
  before_action :set_region, only: %i[ show edit update destroy ]
  after_action :reordenar, only: :destroy

  # GET /regiones or /regiones.json
  def index
    @coleccion = Region.all
  end

  # GET /regiones/1 or /regiones/1.json
  def show
    init_tabla('comunas', @objeto.comunas.order(:comuna), false)
  end

  # GET /regiones/new
  def new
    @objeto = Region.new(orden: Region.all.count + 1)
  end

  # GET /regiones/1/edit
  def edit
  end

  # POST /regiones or /regiones.json
  def create
    @objeto = Region.new(region_params)

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

  # PATCH/PUT /regiones/1 or /regiones/1.json
  def update
    respond_to do |format|
      if @objeto.update(region_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Región fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /regiones/1 or /regiones/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Región fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private

    def reordenar
      @objeto.list.each_with_index do |val, index|
        unless val.orden == index + 1
          val.orden = index + 1
          val.save
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_region
      @objeto = Region.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/tablas?tb=1"
    end

    # Only allow a list of trusted parameters through.
    def region_params
      params.require(:region).permit(:region, :orden)
    end
end
