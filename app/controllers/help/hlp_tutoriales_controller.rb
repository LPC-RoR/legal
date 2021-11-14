class Help::HlpTutorialesController < ApplicationController
  before_action :set_hlp_tutorial, only: %i[ show edit update destroy ]
  before_action :carga_solo_sidebar, only: %i[ show new edit create update ]

  include Sidebar

  # GET /hlp_tutoriales or /hlp_tutoriales.json
  def index
    @coleccion = HlpTutorial.all
  end

  # GET /hlp_tutoriales/1 or /hlp_tutoriales/1.json
  def show
    @coleccion = {}
    @coleccion['hlp_pasos'] = @objeto.hlp_pasos.order(:orden)
  end

  # GET /hlp_tutoriales/new
  def new
    @objeto = HlpTutorial.new
  end

  # GET /hlp_tutoriales/1/edit
  def edit
  end

  # POST /hlp_tutoriales or /hlp_tutoriales.json
  def create
    @objeto = HlpTutorial.new(hlp_tutorial_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Hlp tutorial was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hlp_tutoriales/1 or /hlp_tutoriales/1.json
  def update
    respond_to do |format|
      if @objeto.update(hlp_tutorial_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Hlp tutorial was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hlp_tutoriales/1 or /hlp_tutoriales/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Hlp tutorial was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hlp_tutorial
      @objeto = HlpTutorial.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/app_recursos/administracion?id=#{get_elemento_id(controller_name, 'Tutoriales')}" 
    end

    # Only allow a list of trusted parameters through.
    def hlp_tutorial_params
      params.require(:hlp_tutorial).permit(:tutorial, :clave, :detalle)
    end
end
