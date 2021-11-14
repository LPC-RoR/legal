class Sidebar::SbElementosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :inicia_sesion
  before_action :set_sb_elemento, only: %i[ show edit update destroy ]
  before_action :carga_solo_sidebar, only: %i[ show new edit create update ]

  include Sidebar

  # GET /sb_elementos or /sb_elementos.json
  def index
    @coleccion = SbElemento.all
  end

  # GET /sb_elementos/1 or /sb_elementos/1.json
  def show
  end

  # GET /sb_elementos/new
  def new
    lista = SbLista.find(params[:sb_lista_id])
    @objeto = lista.sb_elementos.new
  end

  # GET /sb_elementos/1/edit
  def edit
  end

  # POST /sb_elementos or /sb_elementos.json
  def create
    @objeto = SbElemento.new(sb_elemento_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Sb elemento was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sb_elementos/1 or /sb_elementos/1.json
  def update
    respond_to do |format|
      if @objeto.update(sb_elemento_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Sb elemento was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sb_elementos/1 or /sb_elementos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Sb elemento was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sb_elemento
      @objeto = SbElemento.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.sb_lista
    end

    # Only allow a list of trusted parameters through.
    def sb_elemento_params
      params.require(:sb_elemento).permit(:orden, :nivel, :tipo, :elemento, :acceso, :activo, :sb_lista_id, :despliegue, :controlador)
    end
end
