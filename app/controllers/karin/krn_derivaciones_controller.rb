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
    ownr = params[:oclss].constantize.find(params[:oid])
    if ['riohs', 'a41', 'seg', 'r_multi', 'd_optn', 'e_optn'].include?(params[:t])
      tipo = ['riohs', 'a41', 'd_optn', 'e_optn'].include?(params[:t]) ? 'Derivación' : 'Recepción'
      motivo = drvcn_mtv[params[:t]]
      fecha = Time.zone.today
      ownr.krn_derivaciones.create(fecha: fecha, tipo: tipo, otro_motivo: motivo)
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