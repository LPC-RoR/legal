class Karin::KrnDenunciantesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_denunciante, only: %i[ show edit update destroy fll_optn del_fld ]

  include Karin

  # GET /krn_denunciantes or /krn_denunciantes.json
  def index
    @coleccion = KrnDenunciante.all
  end

  # GET /krn_denunciantes/1 or /krn_denunciantes/1.json
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

  # GET /krn_denunciantes/new
  def new
#    denuncia = params[:oclss].constantize.find(params[:oid])
    @objeto = KrnDenunciante.new(krn_denuncia_id: params[:oid])
  end

  # GET /krn_denunciantes/1/edit
  def edit
  end

  # POST /krn_denunciantes or /krn_denunciantes.json
  def create
    @objeto = KrnDenunciante.new(krn_denunciante_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Denunciante fue exitósamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_denunciantes/1 or /krn_denunciantes/1.json
  def update
    respond_to do |format|
      if @objeto.update(krn_denunciante_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Denunciante fue exitósamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def fll_optn
    if perfil_activo?
      case params[:k]
      when 'ntfccn'
        @objeto.direccion_notificacion = params[:option]
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
        when 'ntfccn'
          @objeto.direccion_notificacion = nil
        end
      end

      @objeto.save
    end

    redirect_to @objeto.krn_denuncia
  end

  # DELETE /krn_denunciantes/1 or /krn_denunciantes/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Denunciante fue exitósamente eliminado." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_denunciante
      @objeto = KrnDenunciante.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = @objeto.krn_denuncia
    end

    # Only allow a list of trusted parameters through.
    def krn_denunciante_params
      params.require(:krn_denunciante).permit(:krn_denuncia_id, :krn_empresa_externa_id, :rut, :nombre, :cargo, :lugar_trabajo, :email, :email_ok, :articulo_4_1, :articulo_516, :representante)
    end
end
