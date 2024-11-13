class Karin::KrnDenunciadosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_denunciado, only: %i[ show edit update destroy fll_fld fll_cltn_id del_fld ]

  include Karin

  # GET /krn_denunciados or /krn_denunciados.json
  def index
    @coleccion = KrnDenunciado.all
  end

  # GET /krn_denunciados/1 or /krn_denunciados/1.json
  def show
    @etps = Procedimiento.prcdmnt('krn_invstgcn').ctr_etapas.ordr
    krn_dnnc_dc_init(@objeto.krn_denuncia)

    @dsply_dc_fls = {}
    @etps.each do |etp|
      etp.tareas.each do |tar|
        @dsply_dc_fls[tar.id] = tar.rep_doc_controlados.any? ? tar.rep_doc_controlados.map {|dc| @krn_cntrl[dc.codigo] }.include?(true) : false
      end
    end
  end

  # GET /krn_denunciados/new
  def new
    @objeto = KrnDenunciado.new(krn_denuncia_id: params[:oid])
  end

  # GET /krn_denunciados/1/edit
  def edit
  end

  # POST /krn_denunciados or /krn_denunciados.json
  def create
    @objeto = KrnDenunciado.new(krn_denunciado_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Denunciado fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_denunciados/1 or /krn_denunciados/1.json
  def update
    respond_to do |format|
      if @objeto.update(krn_denunciado_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Denunciado fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def fll_fld
    if perfil_activo?
      case params[:k]
      when 'externa_id'
        @objeto.krn_empresa_externa_id = params[:vlr].to_i
      when 'ntfccn'
        @objeto.direccion_notificacion = params[:vlr]
      end
      @objeto.save
    end

    redirect_to @objeto.krn_denuncia
  end

  def fll_cltn_id
    if perfil_activo?
      case params[:k]
      when 'externa_id'
        @objeto.krn_empresa_externa_id = params[:cltn_id].to_i
      end
      @objeto.save
    end

    redirect_to @objeto.krn_denuncia
  end

  def del_fld
    if perfil_activo?
      if [].include?(params[:k])
        del_vlr(@objeto, params[:k])
      else
        case params[:k]
        when 'externa_id'
          @objeto.krn_empresa_externa_id = nil
        when 'ntfccn'
          @objeto.direccion_notificacion = nil
        end
      end

      @objeto.save
    end

    redirect_to @objeto.krn_denuncia
  end

  # DELETE /krn_denunciados/1 or /krn_denunciados/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Denunciado fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_denunciado
      @objeto = KrnDenunciado.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = @objeto.krn_denuncia
    end

    # Only allow a list of trusted parameters through.
    def krn_denunciado_params
      params.require(:krn_denunciado).permit(:krn_denuncia_id, :krn_empresa_externa_id, :rut, :nombre, :cargo, :lugar_trabajo, :email, :email_ok, :articulo_4_1, :articulo_516, :empleado_externo)
    end
end
