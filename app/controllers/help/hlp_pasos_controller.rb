class Help::HlpPasosController < ApplicationController
  before_action :inicia_sesion
  before_action :set_hlp_paso, only: %i[ show edit update destroy ]
  before_action :carga_solo_sidebar, only: %i[ show new edit create update ]

  include Sidebar

  # GET /hlp_pasos or /hlp_pasos.json
  def index
    @coleccion = HlpPaso.all
  end

  # GET /hlp_pasos/1 or /hlp_pasos/1.json
  def show
  end

  # GET /hlp_pasos/new
  def new
    @objeto = HlpPaso.new(hlp_tutorial_id: params[:hlp_tutorial_id])
  end

  # GET /hlp_pasos/1/edit
  def edit
  end

  # POST /hlp_pasos or /hlp_pasos.json
  def create
    @objeto = HlpPaso.new(hlp_paso_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Hlp paso was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hlp_pasos/1 or /hlp_pasos/1.json
  def update
    respond_to do |format|
      if @objeto.update(hlp_paso_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Hlp paso was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hlp_pasos/1 or /hlp_pasos/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Hlp paso was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hlp_paso
      @objeto = HlpPaso.find(params[:id])
    end

    def set_redireccion
      @redireccion = @objeto.hlp_tutorial
    end

    # Only allow a list of trusted parameters through.
    def hlp_paso_params
      params.require(:hlp_paso).permit(:orden, :paso, :detalle, :hlp_tutorial_id)
    end
end
