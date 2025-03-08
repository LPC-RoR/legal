class Recursos::AppEnlacesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_app_enlace, only: %i[ show edit update destroy ]

#  include Bandejas

  # GET /app_enlaces or /app_enlaces.json
  def index
  end

  # GET /app_enlaces/1 or /app_enlaces/1.json
  def show
  end

  # GET /app_enlaces/new
  def new
    ownr_type = (params[:oclss] == 'nil' ? nil : params[:oclss])
    ownr_id = (params[:oid] == 'nil' ? nil : params[:oid])
    @objeto = AppEnlace.new(ownr_type: ownr_type, ownr_id: ownr_id)
  end

  # GET /app_enlaces/1/edit
  def edit
  end

  # POST /app_enlaces or /app_enlaces.json
  def create
    @objeto = AppEnlace.new(app_enlace_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Enlace fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_enlaces/1 or /app_enlaces/1.json
  def update
    respond_to do |format|
      if @objeto.update(app_enlace_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Enlace fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_enlaces/1 or /app_enlaces/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Enlace fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_enlace
      @objeto = AppEnlace.find(params[:id])
    end

    def set_redireccion
      if @objeto.ownr_id.blank? or @objeto.ownr.class.name == 'AppPerfil'
        @redireccion = tabla_path(@objeto)
      elsif ['AppDirectorio', 'TarFactura'].include?(@objeto.ownr.class.name)
        @redireccion = @objeto.ownr
      end
    end

    # Only allow a list of trusted parameters through.
    def app_enlace_params
      params.require(:app_enlace).permit(:descripcion, :enlace, :ownr_type, :ownr_id)
    end
end
