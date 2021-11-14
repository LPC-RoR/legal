class Aplicacion::AppObservacionesController < ApplicationController
  before_action :set_app_observacion, only: [:show, :edit, :update, :destroy]

  # GET /app_observaciones
  # GET /app_observaciones.json
  def index
    @coleccion = AppObservacion.all
  end

  # GET /app_observaciones/1
  # GET /app_observaciones/1.json
  def show
  end

  # GET /app_observaciones/new
  def new
    @objeto = AppObservacion.new(owner_class: params[:class_name], owner_id: params[:objeto_id], app_perfil_id: perfil_activo_id)
  end

  # GET /app_observaciones/1/edit
  def edit
  end

  # POST /app_observaciones
  # POST /app_observaciones.json
  def create
    @objeto = AppObservacion.new(app_observacion_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: 'App observacion was successfully created.' }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_observaciones/1
  # PATCH/PUT /app_observaciones/1.json
  def update
    respond_to do |format|
      if @objeto.update(app_observacion_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: 'App observacion was successfully updated.' }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_observaciones/1
  # DELETE /app_observaciones/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: 'App observacion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_observacion
      @objeto = AppObservacion.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.owner_class.constantize.find(@objeto.owner_id)
    end

    # Only allow a list of trusted parameters through.
    def app_observacion_params
      params.require(:app_observacion).permit(:detalle, :owner_class, :owner_id, :app_perfil_id )
    end
end
