class Modelos::MPeriodosController < ApplicationController
  before_action :set_m_periodo, only: %i[ show edit update destroy ]

  # GET /m_periodos or /m_periodos.json
  def index
    @coleccion = MPeriodo.all
  end

  # GET /m_periodos/1 or /m_periodos/1.json
  def show
    modelo = @objeto.m_modelo
    set_tabla('m_registros', @objeto.m_registros.where(m_item_id: nil).order(:orden), false)
    set_tabla('m_conceptos', modelo.m_conceptos.order(:orden), false)
  end

  # GET /m_periodos/new
  def new
    @objeto = MPeriodo.new
  end

  # GET /m_periodos/1/edit
  def edit
  end

  # POST /m_periodos or /m_periodos.json
  def create
    @objeto = MPeriodo.new(m_periodo_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "M periodo was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /m_periodos/1 or /m_periodos/1.json
  def update
    respond_to do |format|
      if @objeto.update(m_periodo_params)
        format.html { redirect_to @objeto, notice: "M periodo was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /m_periodos/1 or /m_periodos/1.json
  def destroy
    @objeto.destroy
    respond_to do |format|
      format.html { redirect_to m_periodos_url, notice: "M periodo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_m_periodo
      @objeto = MPeriodo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def m_periodo_params
      params.require(:m_periodo).permit(:m_periodo, :clave, :m_modelo_id)
    end
end
