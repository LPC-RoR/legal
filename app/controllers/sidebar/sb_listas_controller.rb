class Sidebar::SbListasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :inicia_sesion
  before_action :set_sb_lista, only: %i[ show edit update destroy ]
  before_action :carga_solo_sidebar, only: %i[ show new edit create update ]

  include Sidebar

  # GET /sb_listas or /sb_listas.json
  def index
    @coleccion = SbLista.all
  end

  # GET /sb_listas/1 or /sb_listas/1.json
  def show
    @coleccion = {}
    @coleccion['sb_elementos'] = @objeto.sb_elementos.order(:orden)
  end

  # GET /sb_listas/new
  def new
    @objeto = SbLista.new
  end

  # GET /sb_listas/1/edit
  def edit
  end

  # POST /sb_listas or /sb_listas.json
  def create
    @objeto = SbLista.new(sb_lista_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Sb lista was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sb_listas/1 or /sb_listas/1.json
  def update
    respond_to do |format|
      if @objeto.update(sb_lista_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Sb lista was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sb_listas/1 or /sb_listas/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Sb lista was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sb_lista
      @objeto = SbLista.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/app_recursos/administracion?id=#{get_elemento_id(controller_name, 'Menús Laterales')}" 
    end

    # Only allow a list of trusted parameters through.
    def sb_lista_params
      params.require(:sb_lista).permit(:lista, :acceso, :link, :activa)
    end
end
