class Karin::KrnDerivacionesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_derivacion, only: %i[ show edit update destroy ]
  before_action :set_bck_rdrccn, only:  %i[ edit update destroy ]

  include Karin

  # GET /krn_derivaciones or /krn_derivaciones.json
  def index
    @coleccion = KrnDerivacion.all
  end

  # GET /krn_derivaciones/1 or /krn_derivaciones/1.json
  def show
  end

  # GET /krn_derivaciones/new
  def new
    drvcn_codes = ClssDrvcn::DRVCN_CDGS
    rcpcn_codes = ClssDrvcn::RCPCN_CDGS
    codes = (drvcn_codes | rcpcn_codes)

    ownr = KrnDenuncia.find(params[:oid])

    if ClssDrvcn.valid?(params[:cdg])
      codigo      = params[:cdg]
      tipo        = ClssDrvcn.tipo(params[:cdg])
      origen      = ownr.donde_estoy?
      destino     = ClssDrvcn.destino(params[:cdg])
      empresa_id  = ownr.externa_id
      motivo      = ClssDrvcn.glosa(params[:cdg].to_sym)

      @objeto = ownr.krn_derivaciones.new(codigo: codigo, tipo: tipo, motivo: motivo, origen: origen, destino: destino, krn_empresa_externa_id: empresa_id)
      set_bck_rdrccn
    end
  end

  # GET /krn_derivaciones/1/edit
  def edit
  end

  # POST /krn_derivaciones or /krn_derivaciones.json
  def create
    @objeto = KrnDerivacion.new(krn_derivacion_params)
    set_bck_rdrccn

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to params[:bck_rdrccn], notice: "Derivacion fue exitosamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_derivaciones/1 or /krn_derivaciones/1.json
  def update
    respond_to do |format|
      if @objeto.update(krn_derivacion_params)
        format.html { redirect_to params[:bck_rdrccn], notice: "Derivacion fue exitosamente actualiada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_derivaciones/1 or /krn_derivaciones/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @bck_rdrccn, notice: "Derivacion fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_derivacion
      @objeto = KrnDerivacion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def krn_derivacion_params
      params.require(:krn_derivacion).permit(:codigo, :krn_denuncia_id, :fecha, :krn_empresa_externa_id, :motivo, :tipo, :origen, :destino)
    end
end