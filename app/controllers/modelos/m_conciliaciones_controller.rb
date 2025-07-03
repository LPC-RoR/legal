class Modelos::MConciliacionesController < ApplicationController
  before_action :set_m_conciliacion, only: %i[ show edit update destroy conciliacion ]

  include Conciliacion

  # GET /m_conciliaciones or /m_conciliaciones.json
  def index
    @coleccion = MConciliacion.all
  end

  # GET /m_conciliaciones/1 or /m_conciliaciones/1.json
  def show
    set_tabla('m_registros', @objeto.m_registros.order(:orden), false)
  end

  # GET /m_conciliaciones/new
  def new
    @objeto = MConciliacion.new(m_cuenta_id: params[:m_cuenta_id])
  end

  # GET /m_conciliaciones/1/edit
  def edit
  end

  # POST /m_conciliaciones or /m_conciliaciones.json
  def create
    @objeto = MConciliacion.new(m_conciliacion_params)

    respond_to do |format|
      if @objeto.save
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Conciliacion fue exitosamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /m_conciliaciones/1 or /m_conciliaciones/1.json
  def update
    respond_to do |format|
      if @objeto.update(m_conciliacion_params)
        set_redireccion
        format.html { redirect_to @redireccion, notice: "Conciliacion fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def conciliacion
    # cargar modelo de negocios
    modelo = @objeto.m_cuenta.m_modelo
    carga_cartola(@objeto)
    # cargar modelo de conciliacion
    # verificar existencia de cargas antriores
    # CONCILIAR

    redirect_to "/m_modelos?id=c_#{@objeto.m_cuenta.id}"
  end

  # DELETE /m_conciliaciones/1 or /m_conciliaciones/1.json
  def destroy
    set_redireccion
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to @redireccion, notice: "Conciliacion fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_m_conciliacion
      @objeto = MConciliacion.find(params[:id])
    end

    def set_redireccion
      @redireccion = "/m_modelos?id=c_#{@objeto.m_cuenta.id}"
    end

    # Only allow a list of trusted parameters through.
    def m_conciliacion_params
      params.require(:m_conciliacion).permit(:m_conciliacion, :m_cuenta_id)
    end
end
