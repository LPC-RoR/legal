class Repositorios::AppImagenesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :inicia_sesion
  before_action :set_app_imagen, only: [:show, :edit, :update, :destroy]

  # GET /app_imagenes
  # GET /app_imagenes.json
  def index
  end

  # GET /app_imagenes/1
  # GET /app_imagenes/1.json
  def show
  end

  # GET /app_imagenes/new
  def new
    @objeto = AppImagen.new(owner_class: params[:class_name], owner_id: params[:objeto_id])
  end

  # GET /app_imagenes/1/edit
  def edit
  end

  # POST /app_imagenes
  # POST /app_imagenes.json
  def create
    @objeto = AppImagen.new(app_imagen_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: 'Imagen fue exitosamente creada.' }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_imagenes/1
  # PATCH/PUT /app_imagenes/1.json
  def update
    respond_to do |format|
      if @objeto.update(app_imagen_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: 'Imagen fue exitosamente actualizada.' }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_imagenes/1
  # DELETE /app_imagenes/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: 'Imagen fue exitosamente eliminada.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_imagen
      @objeto = AppImagen.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.owner_class.constantize.find(@objeto.owner_id)
    end

    # Only allow a list of trusted parameters through.
    def app_imagen_params
      params.require(:app_imagen).permit(:nombre, :imagen, :credito_imagen, :owner_class, :owner_id)
    end
end
