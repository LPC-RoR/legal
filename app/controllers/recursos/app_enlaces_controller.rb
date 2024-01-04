class Recursos::AppEnlacesController < ApplicationController
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
    owner_class = (params[:class_name] == 'nil' ? nil : params[:class_name])
    owner_id = (params[:objeto_id] == 'nil' ? nil : params[:objeto_id])
    @objeto = AppEnlace.new(owner_class: owner_class, owner_id: owner_id)
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
        format.html { redirect_to @redireccion, notice: "App enlace was successfully created." }
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
        format.html { redirect_to @redireccion, notice: "App enlace was successfully updated." }
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
      format.html { redirect_to @redireccion, notice: "App enlace was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_enlace
      @objeto = AppEnlace.find(params[:id])
    end

    def set_redireccion
      if @objeto.owner_id.blank?
          @redireccion = "/tablas?tb=2"
      elsif ['AppDirectorio', 'TarFactura'].include?(@objeto.owner.class.name)
        @redireccion = @objeto.owner
      elsif ['Causa', 'Cliente'].include?(@objeto.objeto_destino.class.name)
        @redireccion = "/#{@objeto.objeto_destino.class.name.tableize.downcase}/#{@objeto.objeto_destino.id}?html_options[menu]=Seguimiento"
      end
    end

    # Only allow a list of trusted parameters through.
    def app_enlace_params
      params.require(:app_enlace).permit(:descripcion, :enlace, :owner_class, :owner_id)
    end
end
