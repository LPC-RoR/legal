class Control::CtrEtapasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_ctr_etapa, only: %i[ show edit update destroy arriba abajo ]
  after_action :reordenar, only: :destroy

  include Orden

  # GET /ctr_etapas or /ctr_etapas.json
  def index
    @coleccion = CtrEtapa.all
  end

  # GET /ctr_etapas/1 or /ctr_etapas/1.json
  def show
    set_tabla('hlp_ayudas', @objeto.hlp_ayudas, false)
    set_tabla('hlp_notas', @objeto.hlp_notas.ordr, false)
    set_tabla('lgl_temas', @objeto.lgl_temas.ordr, false)
  end

  # GET /ctr_etapas/new
  def new
    prcdmnt = params[:oclss].constantize.find(params[:oid])
    orden = prcdmnt.ctr_etapas.count + 1
    @objeto = CtrEtapa.new(procedimiento_id: params[:oid], orden: orden)
  end

  # GET /ctr_etapas/1/edit
  def edit
  end

  # POST /ctr_etapas or /ctr_etapas.json
  def create
    @objeto = CtrEtapa.new(ctr_etapa_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Etapa fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ctr_etapas/1 or /ctr_etapas/1.json
  def update
    respond_to do |format|
      if @objeto.update(ctr_etapa_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Etapa fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ctr_etapas/1 or /ctr_etapas/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Etapa fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ctr_etapa
      @objeto = CtrEtapa.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = @objeto.procedimiento
    end

    # Only allow a list of trusted parameters through.
    def ctr_etapa_params
      params.require(:ctr_etapa).permit(:procedimiento_id, :codigo, :ctr_etapa, :orden)
    end
end
