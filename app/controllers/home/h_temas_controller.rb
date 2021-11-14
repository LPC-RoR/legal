class Home::HTemasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :inicia_sesion
  before_action :set_h_tema, only: [:show, :edit, :update, :destroy]
  before_action :carga_solo_sidebar, only: %i[ show new edit create update ]

  include Sidebar

  # GET /h_temas
  # GET /h_temas.json
  def index
    @coleccion = HTema.all
  end

  # GET /h_temas/1
  # GET /h_temas/1.json
  def show
  end

  # GET /h_temas/new
  def new
    @objeto = HTema.new
  end

  # GET /h_temas/1/edit
  def edit
  end

  # POST /h_temas
  # POST /h_temas.json
  def create
    @objeto = HTema.new(h_tema_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: 'H tema was successfully created.' }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /h_temas/1
  # PATCH/PUT /h_temas/1.json
  def update
    respond_to do |format|
      if @objeto.update(h_tema_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: 'H tema was successfully updated.' }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /h_temas/1
  # DELETE /h_temas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: 'H tema was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_h_tema
      @objeto = HTema.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/app_recursos/administracion?id=#{get_elemento_id(controller_name, 'Temas')}" 
    end

    # Only allow a list of trusted parameters through.
    def h_tema_params
      params.require(:h_tema).permit(:orden, :tema, :imagen, :credito_imagen, :detalle, :activo)
    end
end
