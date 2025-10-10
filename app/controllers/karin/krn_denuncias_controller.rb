class Karin::KrnDenunciasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_denuncia, only: %i[ show edit update destroy swtch niler rlzd prsnt pdf_combinado annmzr set_fld prg ]

  include Karin

  # GET /krn_denuncias or /krn_denuncias.json
  def index
    set_tabla('krn_denuncias', KrnDenuncia.ordr, true)
  end

  # GET /krn_denuncias/1 or /krn_denuncias/1.json
  def show
#    @rprt = DenunciaReport.new(@objeto).to_h
    @acts_hsh = ActLoad.for_tree(@objeto)
    @kproc = KrnPrcdmnt.for(@objeto)

    @age_usuarios = AgeUsuario.where(owner_class: nil, owner_id: nil)

    case @indx
    when 0
    when 1
    when 2
      @combinados = @objeto.act_archivos.where(act_archivo: 'combinado')
      @rprts = @objeto.act_archivos.where(act_archivo: 'dnnc').order(created_at: :desc)
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
        format.html { redirect_to cta_dnncs_path, notice: "Denuncia fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /krn_denuncias/:id/pdf_combinado
  def pdf_combinado

    # (opcional) autorización
    # authorize denuncia

    combinado = @objeto.unir_pdfs!        # genera si aún no existe

    redirect_to "/krn_denuncias/#{@objeto.id}_2"              # redirige a la URL permanente de ActiveStorage
  end

  # DELETE /krn_denuncias/1 or /krn_denuncias/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to cta_dnncs_path, notice: "Denuncia fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  def annmzr
    # Ejecutado donde necesites (job, controlador, consola)
    act = @objeto.act_archivos.find_by(act_archivo: 'denuncia')
    if act
      original_blob = act.pdf.blob

      anonimizador = PdfAnonimizador.new(original_blob)
      pdf_io       = anonimizador.anonimizado_io

      nuevo_act = denuncia.act_archivos.create!(
        tipo: 'anonimizado' # campo extra que puedes tener
      )
      nuevo_act.pdf.attach(
        io: pdf_io,
        filename: "denuncia_#{denuncia.id}_anonimizada.pdf",
        content_type: 'application/pdf'
      )
      ntc = 'Archivo anonimizado creado exitósamente'
    else
      ntc = 'Archivo fuente no encontrado'
    end

    redirect_to "/krn_denuncias/#{@objeto.id}_2", ntc: ntc              # redirige a la URL permanente de ActiveStorage
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

    def cta_dnncs_path
      "/cuentas/#{@objeto.ownr.class.name[0].downcase}_#{@objeto.ownr_id}/dnncs"
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_krn_denuncia
      @tbs = ['Proceso', 'Participantes', 'Reportes']
      prms = params[:id].split('_')
      @indx = prms[1].blank? ? (tipo_usuario == 'recepción' ? 1 : 0) : prms[1].to_i
      @objeto = action_name == 'show' ? KrnDenuncia.estrctr.find(prms[0]) : KrnDenuncia.find(prms[0])
    end

    # Only allow a list of trusted parameters through.
    def krn_denuncia_params
      params.require(:krn_denuncia).permit(:ownr_type, :ownr_id, :identificador, :fecha_hora, :receptor_denuncia, :motivo_denuncia, :krn_empresa_externa_id, :krn_investigador_id, :fecha_hora_dt, :presentado_por, :via_declaracion, :tipo_declaracion, :representante, :auditoria)
    end
end