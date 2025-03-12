class Karin::KrnTestigosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_testigo, only: %i[ show edit update destroy ]

  include Karin

  # GET /krn_testigos or /krn_testigos.json
  def index
    @coleccion = KrnTestigo.all
  end

  # GET /krn_testigos/1 or /krn_testigos/1.json
  def show
    @etps = Procedimiento.prcdmnt('krn_invstgcn').ctr_etapas.ordr
    krn_dnnc_dc_init(@objeto.ownr.krn_denuncia)

    @dsply_dc_fls = {}
    @etps.each do |etp|
      etp.tareas.each do |tar|
        @dsply_dc_fls[tar.id] = tar.rep_doc_controlados.any? ? tar.rep_doc_controlados.map {|dc| @krn_cntrl[dc.codigo] }.include?(true) : false
      end
    end

    set_tabla('krn_declaraciones', @objeto.krn_declaraciones, false)
  end

  # GET /krn_testigos/new
  def new
    @objeto = KrnTestigo.new(ownr_type: params[:oclss], ownr_id: params[:oid])
  end

  # GET /krn_testigos/1/edit
  def edit
  end

  # POST /krn_testigos or /krn_testigos.json
  def create
    @objeto = KrnTestigo.new(krn_testigo_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Testigo fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_testigos/1 or /krn_testigos/1.json
  def update
    respond_to do |format|
      if @objeto.update(krn_testigo_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Testigo fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_testigos/1 or /krn_testigos/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Testigo fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_testigo
      @objeto = KrnTestigo.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = @objeto.ownr.krn_denuncia
    end

    # Only allow a list of trusted parameters through.
    def krn_testigo_params
      params.require(:krn_testigo).permit(:ownr_type, :ownr_id, :empleado_externo, :krn_empresa_externa_id, :rut, :nombre, :cargo, :lugar_trabajo, :email, :email_ok, :articulo_4_1, :articulo_516)
    end
end
