class Home::HLinksController < ApplicationController
  before_action :authenticate_usuario!
  before_action :inicia_sesion
  before_action :set_h_link, only: [:show, :edit, :update, :destroy]
  before_action :carga_solo_sidebar, only: %i[ show new edit create update ]

  include Sidebar

  # GET /h_links
  # GET /h_links.json
  def index
    @coleccion = HLink.all
  end

  # GET /h_links/1
  # GET /h_links/1.json
  def show
  end

  # GET /h_links/new
  def new
    @objeto = HLink.new
  end

  # GET /h_links/1/edit
  def edit
  end

  # POST /h_links
  # POST /h_links.json
  def create
    @objeto = HLink.new(h_link_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: 'H link was successfully created.' }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /h_links/1
  # PATCH/PUT /h_links/1.json
  def update
    respond_to do |format|
      if @objeto.update(h_link_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: 'H link was successfully updated.' }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /h_links/1
  # DELETE /h_links/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: 'H link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_h_link
      @objeto = HLink.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/app_recursos/administracion?id=#{get_elemento_id(controller_name, 'Enlaces')}" 
    end

    # Only allow a list of trusted parameters through.
    def h_link_params
      params.require(:h_link).permit(:tipo, :texto, :link, :owner_class, :owner_id, :activo)
    end
end
