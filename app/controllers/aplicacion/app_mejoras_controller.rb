class Aplicacion::AppMejorasController < ApplicationController
  before_action :set_app_mejora, only: [:show, :edit, :update, :destroy]

  # GET /app_mejoras
  # GET /app_mejoras.json
  def index
    @coleccion = AppMejora.all
  end

  # GET /app_mejoras/1
  # GET /app_mejoras/1.json
  def show
  end

  # GET /app_mejoras/new
  def new
    @objeto = AppMejora.new(owner_class: params[:class_name], owner_id: params[:objeto_id], app_perfil_id: perfil_activo_id, estado: 'ingreso')
  end

  # GET /app_mejoras/1/edit
  def edit
  end

  # POST /app_mejoras
  # POST /app_mejoras.json
  def create
    @objeto = AppMejora.new(app_mejora_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: 'App mejora was successfully created.' }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_mejoras/1
  # PATCH/PUT /app_mejoras/1.json
  def update
    respond_to do |format|
      if @objeto.update(app_mejora_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: 'App mejora was successfully updated.' }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_mejoras/1
  # DELETE /app_mejoras/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: 'App mejora was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_mejora
      @objeto = AppMejora.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.owner_class.constantize.find(@objeto.owner_id)
    end

    # Only allow a list of trusted parameters through.
    def app_mejora_params
      params.require(:app_mejora).permit(:detalle, :estado, :owner_class, :owner_id, :app_perfil_id)
    end
end
