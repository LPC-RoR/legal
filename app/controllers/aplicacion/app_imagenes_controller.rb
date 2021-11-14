class Aplicacion::AppImagenesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :inicia_sesion
  before_action :set_app_imagen, only: [:show, :edit, :update, :destroy]
  before_action :carga_solo_sidebar, only: %i[ show new edit create update ]

  include Sidebar

  # GET /app_imagenes
  # GET /app_imagenes.json
  def index
    @coleccion = AppImagen.all
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
        format.html { redirect_to @redireccion, notice: 'App imagen was successfully created.' }
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
        format.html { redirect_to @redireccion, notice: 'App imagen was successfully updated.' }
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
      format.html { redirect_to @redireccion, notice: 'App imagen was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def carga_solo_sidebar
      carga_sidebar(nombre_sidebar(controller_name), nil)
    end

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
