class Karin::KrnDenunciasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_denuncia, only: %i[ show edit update destroy swtch niler set_fld clear_fld prg ]

  # Si estás usando Devise:
  skip_before_action :authenticate_usuario!, only: [:reporte] 

  include ProcControl
  include Karin

  # GET /krn_denuncias or /krn_denuncias.json
  def index
    set_tabla('krn_denuncias', KrnDenuncia.ordr, true)
  end

  # GET /krn_denuncias/1 or /krn_denuncias/1.json
  def show
    load_objt(@objeto)
    load_proc(@objeto)
    load_temas_proc
    @doc = LglDocumento.find_by(codigo: 'd_rik')
    @prrfs = @doc.lgl_parrafos.ordr.dsplys
    @age_usuarios = AgeUsuario.where(owner_class: nil, owner_id: nil)

    # Se necesita afuera para mostrar Reporte como modal
    set_tabla('krn_denunciantes', @objeto.krn_denunciantes.rut_ordr, false)
    set_tabla('krn_denunciados', @objeto.krn_denunciados.rut_ordr, false)
    set_tabla('krn_derivaciones', @objeto.krn_derivaciones.ordr, false)
    set_tabla('krn_inv_denuncias', @objeto.krn_inv_denuncias.order(:created_at), false)

    case @indx
    when 0
      load_objt_plzs(@objeto)     # Carga plazos
      set_tabla('krn_declaraciones', @objeto.krn_declaraciones.fecha_ordr, false)
    when 1
      load_p_fls
    when 2
      set_tabla('krn_declaraciones', @objeto.krn_declaraciones.fecha_ordr, false)
    end

  end

  # GET /krn_denuncias/new
  def new
    @objeto = KrnDenuncia.new(ownr_type: params[:oclss], ownr_id: params[:oid])
  end

  def tipo_declaracion_field
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          'tipo-declaracion-container',
          partial: 'tipo_declaracion',
          locals: { form: form_for(Declaracion.new) }
        )
      end
    end
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
        format.html { redirect_to "/krn_denuncias/#{@objeto.id}_1", notice: "Denuncia fue exitósamente creada." }
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

    # Use callbacks to share common setup or constraints between actions.
    def set_krn_denuncia
      @tbs = ['Proceso', 'Participantes', 'Agenda']
      prms = params[:id].split('_')
      @indx = prms[1].blank? ? 0 : prms[1].to_i
      @objeto = KrnDenuncia.find(prms[0])
    end

    def get_rdrccn
      @rdrccn = "/cuentas/#{@objeto.ownr.class.name.tableize[0]}_#{@objeto.ownr.id}/dnncs"
    end

    # Only allow a list of trusted parameters through.
    def krn_denuncia_params
      params.require(:krn_denuncia).permit(:ownr_type, :ownr_id, :identificador, :fecha_hora, :receptor_denuncia, :motivo_denuncia, :krn_empresa_externa_id, :krn_investigador_id, :fecha_hora_dt, :presentado_por, :via_declaracion, :tipo_declaracion, :representante)
    end
end