class Karin::KrnDenunciasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_denuncia, only: %i[ show edit update destroy swtch check set_fld clear_fld prg ]
  after_action :set_plzs, only: %i[ create update ]

  include ProcControl
  include Karin

  # GET /krn_denuncias or /krn_denuncias.json
  def index
    set_tabla('krn_denuncias', KrnDenuncia.ordr, true)
  end

  # GET /krn_denuncias/1 or /krn_denuncias/1.json
  def show
    set_plzs
    load_proc(@objeto)
    @age_usuarios = AgeUsuario.where(owner_class: nil, owner_id: nil)

    set_tabla('krn_derivaciones', @objeto.krn_derivaciones.ordr, false)
    set_tabla('krn_denunciantes', @objeto.krn_denunciantes.rut_ordr, false)
    set_tabla('krn_denunciados', @objeto.krn_denunciados.rut_ordr, false)
    set_tabla('krn_declaraciones', @objeto.krn_declaraciones.fecha_ordr, false)
    set_tabla('krn_inv_denuncias', @objeto.krn_inv_denuncias.order(:created_at), false)
    set_tabla('ctr_registros', @objeto.ctr_registros.order(:created_at), false)
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


  def del_vlr(objeto, code)
    code = code == 'drv_rcp_externa' ? 'sgmnt_emprs_extrn' : code
    vlr_nm = code == 'sgmnt_drvcn' ? 'Seguimiento' : code
    vlr = objeto.valor(vlr_nm)
    vlr.delete
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

  def prg
    @objeto.krn_empresa_externa_id = nil
    @objeto.tipo_declaracion = nil
    @objeto.representante = nil
    @objeto.fecha_hora_dt = nil
    @objeto.investigacion_local = nil
    @objeto.solicitud_denuncia = nil
    @objeto.fecha_ntfccn = nil
    @objeto.fecha_trmtcn = nil
    @objeto.fecha_trmn = nil
    @objeto.objcn_invstgdr = nil
    @objeto.evlcn_incmplt = nil
    @objeto.evlcn_incnsstnt = nil
    @objeto.evlcn_ok = nil
    @objeto.fecha_hora_corregida = nil
    @objeto.fecha_trmn = nil
    @objeto.fecha_env_infrm = nil
    @objeto.fecha_prnncmnt = nil
    @objeto.prnncmnt_vncd = nil

    @objeto.ctr_registros.delete_all
    @objeto.krn_denunciantes.delete_all
    @objeto.krn_denunciados.delete_all
    @objeto.krn_inv_denuncias.delete_all
    @objeto.krn_derivaciones.delete_all
    @objeto.krn_declaraciones.delete_all
    @objeto.notas.delete_all
    @objeto.rep_archivos.each do |arch|
      arch.delete
    end

    @objeto.save

    redirect_to @objeto
  end

  private

    # after_action :create :update
    def set_plzs
      # @objeto.fecha_prcsd : Registra la fecha que se utilizó para el cálculo de los plazos
      # Sólo procesa si fecha_hora ha cambiado o recién se crea
#      if @objeto.fecha_hora != @objeto.fecha_prcsd
        @objeto.plz_trmtcn = plz_lv(@objeto.fecha_hora, 3)        # Siempre se cuenta a partir de la fecha de recepción
        fecha_hora = @objeto.fecha_hora_dt? ? @objeto.fecha_hora_dt : @objeto.fecha_hora
        @objeto.plz_invstgcn = plz_lv(fecha_hora, 30)             # Se ajusta a fecha_hora
        @objeto.plz_infrm = plz_lv(@objeto.plz_invstgcn, 2)
        fecha_envio = @objeto.fecha_env_infrm? ? @objeto.fecha_env_infrm : @objeto.plz_infrm
        @objeto.plz_prnncmnt = @objeto.on_dt? ? nil : plz_lv(fecha_envio, 30)
        fecha_prnncmnt = @objeto.on_dt? ? fecha_envio : @objeto.plz_prnncmnt
        @objeto.plz_mdds_sncns = plz_c(fecha_prnncmnt, 15)

#        @objeto.fecha_prcsd = @objeto.fecha_hora

        @objeto.save
#      end
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