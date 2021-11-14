class Home::HImagenesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :inicia_sesion
  before_action :set_h_imagen, only: [:show, :edit, :update, :destroy]
  before_action :carga_solo_sidebar, only: %i[ show new edit create update ]

  include Sidebar

  # GET /h_imagenes
  # GET /h_imagenes.json
  def index
    @coleccion = HImagen.all
  end

  # GET /h_imagenes/1
  # GET /h_imagenes/1.json
  def show
  end

  # GET /h_imagenes/new
  def new
    @objeto = HImagen.new
  end

  # GET /h_imagenes/1/edit
  def edit
  end

  # POST /h_imagenes
  # POST /h_imagenes.json
  def create
    @objeto = HImagen.new(h_imagen_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: 'H imagen was successfully created.' }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /h_imagenes/1
  # PATCH/PUT /h_imagenes/1.json
  def update
    respond_to do |format|
      if @objeto.update(h_imagen_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: 'H imagen was successfully updated.' }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /h_imagenes/1
  # DELETE /h_imagenes/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: 'H imagen was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_h_imagen
      @objeto = HImagen.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/app_recursos/administracion?id=#{get_elemento_id(controller_name, 'Imágenes')}" 
    end

    # Only allow a list of trusted parameters through.
    def h_imagen_params
      params.require(:h_imagen).permit(:nombre)
    end
end
