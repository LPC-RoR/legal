class Karin::KrnDenunciasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_denuncia, only: %i[ show edit update destroy check ]

  include Karin

  # GET /krn_denuncias or /krn_denuncias.json
  def index
#    set_tabla('krn_denuncias', KrnDenuncia.all.order(fecha_hora: :desc), true)
    set_tabla('krn_denuncias', KrnDenuncia.ordr, true)
  end

  # GET /krn_denuncias/1 or /krn_denuncias/1.json
  def show
    set_tab( :menu, [['General', operacion?], ['Hechos', operacion?], ['Medidas', operacion?], ['Documentos', operacion?]] )

    case @options[:menu]
    when 'General'
      krn_dnnc_dc_init(@objeto)
      set_tabla('krn_denunciantes', @objeto.krn_denunciantes.ordr, false)
      set_tabla('krn_denunciados', @objeto.krn_denunciados.ordr, false)
      set_tabla('krn_derivaciones', @objeto.krn_derivaciones.ordr, false)
    end
  end

  # GET /krn_denuncias/new
  def new
    cliente_id = params[:oclss] == 'Cliente' ? params[:oid] : nil
    empresa_id = params[:oclss] == 'Empresa' ? params[:oid] : nil
    @objeto = KrnDenuncia.new(cliente_id: cliente_id, empresa_id: empresa_id)
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

  def check
    if params[:i_optns].present?
      if params[:i_optns] == 'i_optns'
        @objeto.info_opciones = true
      else
        @objeto.info_opciones = nil
      end
    end
    if params[:d_optn].present?
      if ['empresa', 'externa', 'dt'].include?(params[:d_optn])
        @objeto.dnncnt_opcion = params[:d_optn]
      else
        @objeto.dnncnt_opcion = nil
      end
    end
    if params[:e_optn].present?
      if ['empresa', 'dt'].include?(params[:e_optn])
        @objeto.emprs_opcion = params[:e_optn]
      else
        @objeto.emprs_opcion = nil
      end
    end
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
      @rdrccn = "/#{@objeto.owner.class.name.tableize}/#{@objeto.owner.id}?html_options[menu]=Investigaciones"
    end

    # Only allow a list of trusted parameters through.
    def krn_denuncia_params
      params.require(:krn_denuncia).permit(:cliente_id, :receptor_denuncia_id, :empresa_receptora_id, :motivo_denuncia_id, :investigador_id, :fecha_hora, :fecha_hora_dt, :fecha_hora_recepcion, :dnnte_info_derivacion, :dnnte_derivacion, :dnnte_entidad_investigacion, :dnnte_empresa_investigacion_id, :empresa_id, :presentado_por, :via_declaracion, :tipo_declaracion)
    end
end
