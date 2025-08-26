class Karin::KrnDenunciasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_denuncia, only: %i[ show edit update destroy swtch niler set_fld clear_fld prg ]
  before_action :set_bck_rdrccn, only:  %i[ edit update destroy ]

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

    set_tab(:menu, ['Proceso', 'Participantes'])

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
      @pdf_rvsn = PdfArchivo.find_by(codigo: 'infrmcn')
      @pdf_rgstr_rvsn = @objeto.pdf_registros.where(pdf_archivo_id: @pdf_rvsn.id)
    when 2
#      set_tabla('krn_declaraciones', @objeto.krn_declaraciones.fecha_ordr, false)
      set_tabla('pdf_archivos', @objeto.prcdmnt.pdf_archivos.where(codigo: rprts_pdf_actvs).ordr, false)
      set_tabla('pdf_registros', @objeto.pdf_registros.order(:created_at), false)
    end

  end

  # GET /krn_denuncias/new
  def new
    @objeto = KrnDenuncia.new(ownr_type: params[:oclss], ownr_id: params[:oid], fecha_hora: Time.zone.now)
    set_bck_rdrccn
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
    set_bck_rdrccn
    respond_to do |format|
      if @objeto.save
        format.html { redirect_to "/krn_denuncias/#{@objeto.id}_1", notice: "Denuncia fue exitosamente creada." }
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
        format.html { redirect_to params[:bck_rdrccn], notice: "Denuncia fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /krn_denuncias/1 or /krn_denuncias/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to @bck_rdrccn, notice: "Denuncia fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  def prg
    @objeto.rep_archivos.each do |arch|
      arch.delete
    end

    @objeto.pdf_registros.delete_all

    @objeto.notas.each do |nota|
      nota.age_usu_notas.delete_all
      nota.delete
    end

    @objeto.krn_denunciantes.each do |dnncnt|
      dnncnt.rep_archivos.each do |arch|
        arch.delete
      end
      dnncnt.notas.each do |nota|
        nota.age_usu_notas.delete_all
        nota.delete
      end
      dnncnt.pdf_registros.delete_all
      dnncnt.krn_declaraciones.each do |dclrcn|
        dclrcn.pdf_registros.delete_all
        dclrcn.delete
      end
      dnncnt.krn_testigos.each do |tstg|
        tstg.rep_archivos.each do |arch|
          arch.delete
        end
        tstg.pdf_registros.delete_all
        tstg.krn_declaraciones.each do |dclrcn|
          dclrcn.pdf_registros.delete_all
          dclrcn.delete
        end
        tstg.delete
      end
      dnncnt.delete
    end

    @objeto.krn_denunciados.each do |dnncd|
      dnncd.rep_archivos.each do |arch|
        arch.delete
      end
      dnncd.notas.each do |nota|
        nota.age_usu_notas.delete_all
        nota.delete
      end
      dnncd.pdf_registros.delete_all
      dnncd.krn_declaraciones.each do |dclrcn|
        dclrcn.pdf_registros.delete_all
        dclrcn.delete
      end
      dnncd.krn_testigos.each do |tstg|
        tstg.rep_archivos.each do |arch|
          arch.delete
        end
        tstg.pdf_registros.delete_all
        tstg.krn_declaraciones.each do |dclrcn|
          dclrcn.pdf_registros.delete_all
          dclrcn.delete
        end
        tstg.delete
      end
      dnncd.delete
    end

    @objeto.krn_derivaciones.each do |drvcn|
      drvcn.pdf_registros.delete_all
      drvcn.delete
    end

    @objeto.krn_inv_denuncias.delete_all

    @objeto.krn_empresa_externa_id = nil
    @objeto.investigacion_local = nil
    @objeto.investigacion_externa = nil
    @objeto.solicitud_denuncia = nil
    @objeto.fecha_ntfccn = nil
    @objeto.fecha_trmtcn = nil
    @objeto.fecha_hora_dt = nil
    @objeto.objcn_invstgdr = nil
    @objeto.evlcn_incnsstnt = nil
    @objeto.evlcn_ok = nil
    @objeto.fecha_hora_corregida = nil
    @objeto.fecha_trmn = nil
    @objeto.fecha_env_infrm = nil
    @objeto.fecha_prnncmnt = nil
    @objeto.prnncmnt_vncd = nil
    @objeto.fecha_cierre = nil

    @objeto.save

    redirect_to @objeto
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_krn_denuncia
      @tbs = ['Proceso', 'Participantes', 'Reportes']
      prms = params[:id].split('_')
      @indx = prms[1].blank? ? (tipo_usuario == 'recepción' ? 1 : 0) : prms[1].to_i
      @objeto = KrnDenuncia.find(prms[0])
    end

    # Only allow a list of trusted parameters through.
    def krn_denuncia_params
      params.require(:krn_denuncia).permit(:ownr_type, :ownr_id, :identificador, :fecha_hora, :receptor_denuncia, :motivo_denuncia, :krn_empresa_externa_id, :krn_investigador_id, :fecha_hora_dt, :presentado_por, :via_declaracion, :tipo_declaracion, :representante)
    end
end