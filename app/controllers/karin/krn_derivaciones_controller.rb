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
  end

  def nueva
    drvcn_codes = ['riohs', 'a41', 'd_optn', 'e_optn', 'extrn']
    rcpcn_codes = ['rcptn', 'r_multi']
    extrn_codes = ['rcptn', 'extrn_dt']
    codes = (drvcn_codes | rcpcn_codes | extrn_codes)
    ownr = params[:oclss].constantize.find(params[:oid])
    if codes.include?(params[:t])
      if drvcn_codes.include?(params[:t])
        tipo = 'Derivación'
        origen = 'Empresa'
        destino = params[:t] == 'extrn' ? 'Externa' : 'Dirección del Trabajo'
      elsif extrn_codes.include?(params[:t])
        tipo = params[:t] == 'rcptn' ? 'Recepción' : 'Derivación'
        origen = 'Externa'
        destino = params[:t] == 'rcptn' ? 'Empresa' : 'Dirección del Trabajo'
      end
      empresa_id = ownr.krn_empresa_externa_id
      motivo = drvcn_mtv[params[:t]]
      fecha = Time.zone.today
      ownr.krn_derivaciones.create(fecha: fecha, tipo: tipo, motivo: motivo, origen: origen, destino: destino, krn_empresa_externa_id: empresa_id)
    end

    redirect_to ownr
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