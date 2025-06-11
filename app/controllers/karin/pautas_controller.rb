class Karin::PautasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_pauta, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: :destroy

  include Orden

  # GET /pautas or /pautas.json
  def index
    set_tabla('pautas', Pauta.all.order(:orden), false)
  end

  # GET /pautas/1 or /pautas/1.json
  def show
    set_tabla('cuestionarios', @objeto.cuestionarios.order(:orden), false)
  end

  # GET /pautas/new
  def new
    orden = Pauta.all.count + 1
    @objeto = Pauta.new(orden: orden)
  end

  # GET /pautas/1/edit
  def edit
  end

  # POST /pautas or /pautas.json
  def create
    @objeto = Pauta.new(pauta_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @rdrccn, notice: "Pauta fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pautas/1 or /pautas/1.json
  def update
    respond_to do |format|
      if @objeto.update(pauta_params)
        set_redireccion
        format.html { redirect_to @rdrccn, notice: "Pauta fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pautas/1 or /pautas/1.json
  def destroy
    set_redireccion
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Pauta fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pauta
      @objeto = Pauta.find(params[:id])
    end

    def set_redireccion
      @rdrccn = pautas_path
    end

    # Only allow a list of trusted parameters through.
    def pauta_params
      params.require(:pauta).permit(:orden, :pauta, :referencia)
    end
end
