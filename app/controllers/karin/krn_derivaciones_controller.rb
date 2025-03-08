class Karin::KrnDerivacionesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_derivacion, only: %i[ show edit update destroy ]

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
    drvcn_codes = ['drvcn_art4_1', 'drvcn_dnncnt', 'drvcn_emprs']
    # Recepción de derivaciones ( desde empresa_externa o dt)
    rcpcn_codes = ['rcptn_extrn', 'rcpcn_dt']
    codes = (drvcn_codes | rcpcn_codes)

    ownr = KrnDenuncia.find(params[:oid])

    if codes.include?(params[:cdg])
      tipo = drvcn_codes.include?(params[:cdg]) ? 'Derivación' : 'Recepción'
      origen = ownr.on_dt? ? 'Dirección del Trabajo' : ( ownr.on_empresa? ? 'Empresa' : 'Externa' )
      destino = rcpcn_codes.include?(params[:cdg]) ? 'Empresa' : ( params[:cdg] == 'drvcn_ext' ? 'Externa' : 'Dirección del Trabajo' )
      empresa_id = ( ownr.on_externa? and ownr.krn_derivaciones.empty? ) ? ownr.krn_empresa_externa_id : ( ownr.on_externa? ? ( ownr.krn_derivaciones.empty? ? ownr.krn_empresa_externa_id :  ) : nil )
      if ownr.on_externa?
        empresa_id = ownr.krn_derivaciones.empty? ? ownr.krn_empresa_externa_id : ownr.krn_derivaciones.last.krn_empresa_externa_id
      elsif params[:cdg] == 'drvcn_ext'
        empresa_id = ownr.empleador
      else
        nil
      end
      motivo = drvcn_text[params[:cdg].to_sym][:gls]

      @objeto = ownr.krn_derivaciones.create(tipo: tipo, motivo: motivo, origen: origen, destino: destino, krn_empresa_externa_id: empresa_id)
    end
  end

  # GET /krn_derivaciones/1/edit
  def edit
  end

  # POST /krn_derivaciones or /krn_derivaciones.json
  def create
    @objeto = KrnDerivacion.new(krn_derivacion_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Derivacion fue exitósamente creada." }
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
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Derivacion fue exitósamente actualiada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_derivaciones/1 or /krn_derivaciones/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Derivacion fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_derivacion
      @objeto = KrnDerivacion.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = @objeto.krn_denuncia
    end

    # Only allow a list of trusted parameters through.
    def krn_derivacion_params
      params.require(:krn_derivacion).permit(:krn_denuncia_id, :fecha, :krn_empresa_externa_id, :krn_motivo_derivacion_id, :otro_motivo, :tipo, :destino)
    end
end