class Recursos::RegionesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_region, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: :destroy

  # GET /regiones or /regiones.json
  def index
    @coleccion = Region.all
  end

  # GET /regiones/1 or /regiones/1.json
  def show
    set_tabla('comunas', @objeto.comunas.order(:comuna), false)
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
        format.html { redirect_to @redireccion, notice: "Región fue exitosamente creada." }
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
        format.html { redirect_to @redireccion, notice: "Región fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def arriba
    owner = @objeto.owner
    anterior = @objeto.anterior
    @objeto.orden -= 1
    @objeto.save
    anterior.orden += 1
    anterior.save

    redirect_to @objeto.redireccion
  end

  def abajo
    owner = @objeto.owner
    siguiente = @objeto.siguiente
    @objeto.orden += 1
    @objeto.save
    siguiente.orden -= 1
    siguiente.save

    redirect_to @objeto.redireccion
  end

  # DELETE /regiones/1 or /regiones/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Región fue exitosamente eliminada." }
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
      @redireccion = tabla_path(@objeto)
    end

    # Only allow a list of trusted parameters through.
    def region_params
      params.require(:region).permit(:region, :orden)
    end
end
