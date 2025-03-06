class Karin::KrnDenunciasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_denuncia, only: %i[ show edit update destroy check set_fld clear_fld fll_dttm fll_fld fll_optn del_fld fll_cltn_id ]
  after_action :set_plzs, only: %i[ create update ]
  after_action :load_proc, only: %i[ create update ]

  include Karin

  # GET /krn_denuncias or /krn_denuncias.json
  def index
    set_tabla('krn_denuncias', KrnDenuncia.ordr, true)
  end

  # GET /krn_denuncias/1 or /krn_denuncias/1.json
  def show
    get_dnnc_jot(@objeto)

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
    set_tabla('krn_declaraciones', @objeto.krn_declaraciones.fecha_ordr, false)
  end

  # GET /krn_denuncias/new
  def new
    @objeto = KrnDenuncia.new(ownr_type: params[:oclss], ownr_id: params[:oid])
  end

  # GET /krn_denuncias/1/edit
  def edit
  end

  def cndtnl_via_declaracion
    @data = KrnDenuncia.recent_data
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


  def fll_fld
    if perfil_activo?
      case params[:k]
      when 'externa'
        @objeto.krn_empresa_externa_id = params[:krn_empresa_externa_id].to_i
      when 'tipo'
        @objeto.tipo_declaracion = params[:tipo_declaracion]
      when 'representante'
        @objeto.representante = params[:representante]
      when 'via'
        @objeto.via_declaracion = params[:vlr]
      when 'drv_fecha_dt'
        @objeto.fecha_hora_dt = params_to_date(params, 'vlr')
        set_lgl_plzs(true)
      when 'dnnc_fecha_trmtcn'
        @objeto.fecha_trmtcn = params_to_date(params, 'vlr')
      when 'dnnc_fecha_ntfccn'
        @objeto.fecha_ntfccn = params_to_date(params, 'vlr')
      when 'dnnc_invstgdr'
        invstgdr = KrnInvestigador.find(params[:vlr].to_i)
        @objeto.krn_investigadores << invstgdr
      when 'dnnc_invstgdr'
        invstgdr = KrnInvestigador.find(params[:vlr].to_i)
        @objeto.krn_investigadores << invstgdr
      when 'dnnc_fecha_crrgd'
        @objeto.fecha_hora_corregida = params_to_date(params, 'vlr')
      when 'dnnc_fecha_ntfccn_invstgdr'
        @objeto.fecha_ntfccn_invstgdr = params_to_date(params, 'vlr')
      when 'dnnc_fecha_trmn'
        @objeto.fecha_trmn = params_to_date(params, 'vlr')
      when 'dnnc_fecha_env'
        @objeto.fecha_env_infrm = params_to_date(params, 'vlr')
      when 'dnnc_fecha_prnncmnt'
        @objeto.fecha_prnncmnt = params_to_date(params, 'vlr')
      when 'dnnc_fecha_mdds_sncns'
        @objeto.fecha_prcsd = params_to_date(params, 'vlr')
      end
      @objeto.save

      @objeto.ctr_registros
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
    code = code == 'drv_rcp_externa' ? 'sgmnt_emprs_extrn' : code
    vlr_nm = code == 'sgmnt_drvcn' ? 'Seguimiento' : code
    vlr = objeto.valor(vlr_nm)
    vlr.delete
  end

  def del_fld
    if perfil_activo?
      if ['drv_inf_dnncnt', 'drv_dnncnt_optn', 'drv_emprs_optn', 'dnnc_objcn_invstgdr', 'drv_rcp_externa', 'dnnc_rslcn_objcn', 'dnnc_eval_ok', 'dnnc_infrm_invstgcn_dt', 'dnnc_crr_dclrcns', 'dnnc_infrm_dt'].include?(params[:k])
        del_vlr(@objeto, params[:k])
      else
        case params[:k]
        when 'externa_id'
          @objeto.krn_empresa_externa_id = nil
        when 'via'
          @objeto.via_declaracion = nil
        when 'tipo'
          @objeto.tipo_declaracion = nil
        when 'representante'
          @objeto.representante = nil
        when 'drv_fecha_dt'
          @objeto.fecha_hora_dt = nil
          set_lgl_plzs(false)
        when 'dnnc_fecha_ntfccn'
          @objeto.fecha_ntfccn = nil
        when 'dnnc_fecha_trmtcn'
          @objeto.fecha_trmtcn = nil
        when 'dnnc_invstgdr'
          invstgdr = @objeto.krn_investigadores.first
          @objeto.krn_investigadores.delete(invstgdr)
        when 'dnnc_invstgdr_objcn'
          invstgdr = @objeto.krn_investigadores.second
          @objeto.krn_investigadores.delete(invstgdr)
        when 'fecha_crrgd'
          @objeto.fecha_hora_corregida = nil
        when 'dnnc_fecha_crrgd'
          @objeto.fecha_hora_corregida = nil
        when 'dnnc_fecha_ntfccn_invstgdr'
          @objeto.fecha_ntfccn_invstgdr = nil
        when 'dnnc_fecha_trmn'
          @objeto.fecha_trmn = nil
        when 'dnnc_fecha_env'
          @objeto.fecha_env_infrm = nil
        when 'dnnc_fecha_prnncmnt'
          @objeto.fecha_prnncmnt = nil
        when 'dnnc_fecha_mdds_sncns'
          @objeto.fecha_prcsd = nil
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

    def set_plzs
      if @objeto.fecha_hora != @objeto.fecha_prcsd
        @objeto.plz_trmtcn = plz_lv(@objeto.fecha_hora, 3)
        @objeto.plz_invstgcn = plz_lv(@objeto.fecha_hora, 30)
        @objeto.plz_infrm = plz_lv(@objeto.fecha_hora, 32)
        @objeto.plz_prnncmnt = plz_lv(@objeto.fecha_hora, 62)
        @objeto.plz_mdds_sncns = plz_c(@objeto.plz_prnncmnt, 15)
        @objeto.fecha_prcsd = @objeto.fecha_hora

        @objeto.save
      end
    end

    def set_lgl_plzs(flag)
      fecha_ref = flag ? @objeto.fecha_hora_dt : @objeto.fecha_hora
      @objeto.plz_invstgcn   = plz_lv(fecha_ref, 30)
      @objeto.plz_infrm      = flag ? nil : plz_lv(fecha_ref, 32)
      @objeto.plz_prnncmnt   = flag ? nil : plz_lv(fecha_ref, 62)
      @objeto.plz_mdds_sncns = flag ? plz_c(@objeto.plz_invstgcn, 15) : plz_c(@objeto.plz_prnncmnt, 15)
    end

    # --------------------------------------------------------------------- PROC

    def load_proc
      prcdmnt = Procedimiento.find_by(codigo: KrnDenuncia::PROC)
#      tar = Tarea.find_by(codigo: '010_ingrs')
      tar = prcdmnt.tareas.ordr.first
      tar.ctr_pasos.init.ordr.each do |ctr_paso|

        # el método se llama para create y update
        reg = @objeto.ctr_registros.find_by(ctr_paso_id: ctr_paso.id)

        if ctr_paso.glosa.blank?
          case ctr_paso.codigo
          when 'ownr'
            glosa = @objeto.ownr.class.name
          end
        else
          glosa = ctr_paso.glosa
        end

        mtd = ctr_paso.despliega.blank? ? ctr_paso.metodo : ctr_paso.despliega
        vlr = @objeto.send(ctr_paso.metodo)

        if ctr_paso.codigo == 'fecha_hora'
          valor = vlr.blank? ? '__-__-__ __:__' : vlr.strftime("%d-%m-%Y  %I:%M%p")
        else
          valor = vlr
        end

        if reg.blank?
          @objeto.ctr_registros.create(orden: ctr_paso.orden, tarea_id: tar.id, ctr_paso_id: ctr_paso.id, glosa: glosa, valor: valor)
        else
          reg.glosa = glosa
          reg.valor = vlr
          reg.save
        end
      end
    end

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