class Recursos::ComunasController < ApplicationController
  before_action :set_comuna, only: %i[ show edit update destroy ]

  # GET /comunas or /comunas.json
  def index
    @coleccion = Comuna.all
  end

  # GET /comunas/1 or /comunas/1.json
  def show
  end

  # GET /comunas/new
  def new
    @objeto = Comuna.new(region_id: params[:region_id])
  end

  # GET /comunas/1/edit
  def edit
  end

  # POST /comunas or /comunas.json
  def create
    @objeto = Comuna.new(comuna_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Comuna fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comunas/1 or /comunas/1.json
  def update
    respond_to do |format|
      if @objeto.update(comuna_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Comuna fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comunas/1 or /comunas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Comuna fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comuna
      @objeto = Comuna.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.region
    end

    # Only allow a list of trusted parameters through.
    def comuna_params
      params.require(:comuna).permit(:comuna, :region_id)
    end
end
