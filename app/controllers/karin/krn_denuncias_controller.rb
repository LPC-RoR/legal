class Karin::KrnDenunciasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_denuncia, only: %i[ show edit update destroy check fll_dttm fll_fld fll_optn del_fld fll_cltn_id ]

  include Karin

  # GET /krn_denuncias or /krn_denuncias.json
  def index
#    set_tabla('krn_denuncias', KrnDenuncia.all.order(fecha_hora: :desc), true)
    set_tabla('krn_denuncias', KrnDenuncia.ordr, true)
  end

  # GET /krn_denuncias/1 or /krn_denuncias/1.json
  def show
    set_tab( :menu, [['Denuncia', operacion?], ['Persona(s) Denunciante(s)', operacion?], ['Persona(s) Denunciada(s)', operacion?]] )

    @etps = Procedimiento.prcdmnt('krn_invstgcn').ctr_etapas.ordr
    krn_dnnc_dc_init(@objeto)

    @dsply_dc_fls = {}
    @etps.each do |etp|
      etp.tareas.each do |tar|
        @dsply_dc_fls[tar.id] = tar.rep_doc_controlados.any? ? tar.rep_doc_controlados.map {|dc| @krn_cntrl[dc.codigo] }.include?(true) : false
      end
    end

    set_tabla('krn_derivaciones', @objeto.krn_derivaciones.ordr, false)
    set_tabla('krn_denunciantes', @objeto.krn_denunciantes.rut_ordr, false)
    set_tabla('krn_denunciados', @objeto.krn_denunciados.rut_ordr, false)
  end

  # GET /krn_denuncias/new
  def new
    @objeto = KrnDenuncia.new(ownr_type: params[:oclss], ownr_id: params[:oid])
  end

  # GET /krn_denuncias/1/edit
  def edit
  end

  # POST /krn_denuncias or /krn_denuncias.json
  def create
    @objeto = KrnDenuncia.new(krn_denuncia_params)

    respond_to do |format|
      if @objeto.save
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Denuncia fue exitósamente creada." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_denuncias/1 or /krn_denuncias/1.json
  def update
    respond_to do |format|
      if @objeto.update(krn_denuncia_params)
        get_rdrccn
        format.html { redirect_to @rdrccn, notice: "Denuncia fue exitósamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def fll_dttm
    if perfil_activo?
      case params[:k]
      when 'fecha_crrgd'
        @objeto.fecha_hora_corregida = params_to_date(params, 'fecha')
      when 'fecha_dt'
        @objeto.fecha_hora_dt = params_to_date(params, 'fecha')
      end
      @objeto.save
    end

    redirect_to @objeto
  end

  def fll_optn
    if perfil_activo?
      case params[:k]
      when 'via'
        @objeto.via_declaracion = params[:option]
      when 'tipo'
        @objeto.tipo_declaracion = params[:option]
      when 'presentada'
        @objeto.presentado_por = params[:option]
      when 'representante'
        @objeto.representante = params[:option]
      end
      @objeto.save
    end

    redirect_to @objeto
  end

  def fll_cltn_id
    if perfil_activo?
      case params[:k]
      when 'externa_id'
        @objeto.krn_empresa_externa_id = params[:cltn_id]
      end
      @objeto.save
    end

    redirect_to @objeto
  end

  def del_vlr(objeto, code)
    vlr_nm = code == 'sgmnt_drvcn' ? 'Seguimiento' : code
    vlr = objeto.valor(vlr_nm)
    vlr.delete
  end

  def del_fld
    if perfil_activo?
      if ['sgmnt_drvcn', 'inf_dnncnt', 'd_optn_invstgcn', 'e_optn_invstgcn', 'dnnc_infrm_invstgcn_dt', 'dnnc_leida', 'dnnc_incnsstnt', 'dnnc_incmplt', 'dnnc_crr_dclrcns', 'dnnc_infrm_dt', 'objcn_invstgdr'].include?(params[:k])
        del_vlr(@objeto, params[:k])
      else
        case params[:k]
        when 'fecha_dt'
          @objeto.fecha_hora_dt = nil
        when 'fecha_crrgd'
          @objeto.fecha_hora_corregida = nil
        when 'tipo'
          @objeto.tipo_declaracion = nil
        when 'externa_id'
          @objeto.krn_empresa_externa_id = nil
        when 'representante'
          @objeto.representante = nil
        when 'invstgdr'
          @objeto.krn_investigador_id = nil
        end
      end

      @objeto.save
    end

    redirect_to @objeto
  end

  def check
    if params[:invstgdr].present?
      unless params[:invstgdr] == 'erase'
        @objeto.krn_investigador_id = params[:invstgdr].to_i
      else
        @objeto.krn_investigador_id = nil
      end
    end
    if params[:leida].present?
      if params[:leida] == 'leida'
        @objeto.leida = true
      else
        @objeto.leida = nil
      end
    end
    if params[:incnsstnt].present?
      if ['s', 'n'].include?(params[:incnsstnt])
        @objeto.incnsstnt = params[:incnsstnt] == 's' ? true : false
      else
        @objeto.incnsstnt = nil
      end
    end
    if params[:incmplt].present?
      if ['s', 'n'].include?(params[:incmplt])
        @objeto.incmplt = params[:incmplt] == 's' ? true : false
      else
        @objeto.incmplt = nil
      end
    end

    @objeto.save

    redirect_to @objeto
  end

  # DELETE /krn_denuncias/1 or /krn_denuncias/1.json
  def destroy
    get_rdrccn
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @rdrccn, notice: "Denuncia fue exitósamente eliminada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_krn_denuncia
      @objeto = KrnDenuncia.find(params[:id])
    end

    def get_rdrccn
      @rdrccn = "/cuentas/#{@objeto.ownr.id}/#{@objeto.ownr.class.name.tableize[0]}dnncs"
    end

    # Only allow a list of trusted parameters through.
    def krn_denuncia_params
      params.require(:krn_denuncia).permit(:ownr_type, :ownr_id, :fecha_hora, :receptor_denuncia, :motivo_denuncia, :empresa_receptora_id, :krn_investigador_id, :fecha_hora_dt, :dnnte_info_derivacion, :dnnte_derivacion, :dnnte_entidad_investigacion, :dnnte_empresa_investigacion_id, :empresa_id, :presentado_por, :via_declaracion, :tipo_declaracion)
    end
end