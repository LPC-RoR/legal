class Karin::KrnDenunciasController < ApplicationController
  before_action :authenticate_usuario!
  before_action :scrty_on
  before_action :set_krn_denuncia, only: %i[ show edit update destroy cargar_pdf combinar_pdf cambiar_etapa anonimizar_expediente swtch niler rlzd prsnt pdf_combinado pdf_designacion pdf_notificaciones pdf_declaraciones pdf_pruebas annmzr set_fld prg krn_pdf_rprt ]

  include PdfGeneratable
  include PdfCombinable

  # REVISAR Reemplazo con PdfGeneratable
  include MailDesk
  include Karin

  # GET /krn_denuncias or /krn_denuncias.json
  def index
    set_tabla('krn_denuncias', KrnDenuncia.ordr, true)
  end

  # GET /krn_denuncias/1 or /krn_denuncias/1.json
  def show
    # Para simpificar parciales, están en @act_hsh

    # En el despliegue de KrnDenuncia ya no se usa ActLoad pero se usa en algún reporte, probablemnte en dnnc
    @kproc = KrnPrcdmnt.for(@objeto)

    # Plazos disponibles para todos los tabs
    @plazos = @objeto.plazos 
    case @indx
    when 0
    when 1
    when 2
    when 3
      # --- Variable única para el tab de plazos ---
      
      # Opcional: si quieres alertas globales en el header de la página
      @alerta_activa = @plazos.any? { |p| p[:estado] == :proximo || p[:aprobado_por_vencimiento] }
      @incumplimientos = @plazos.select { |p| p[:incumplido] }
    when 4
      @combinados   = @objeto.act_archivos.where(act_archivo: 'combinado')
      @rcrss_infrm  = @objeto.act_archivos.where(act_archivo: ['dsgncn_invstgdr', 'ntfccns', 'dclrcns', 'mds_prb'])
      @rprts        = @objeto.act_archivos.where(act_archivo: 'dnnc').order(created_at: :desc)
      @st_dclrcns   = @objeto.act_archivos.where(act_archivo: 'st_dclrcns').order(created_at: :desc)
    end

  end

  def cambiar_etapa
    destino = params[:etapa_destino]
    idx_actual = KrnDenuncia::ETAPAS.index(@objeto.etapa)
    idx_destino = KrnDenuncia::ETAPAS.index(destino)

    unless idx_destino && (idx_destino - idx_actual).abs == 1
      flash[:alert] = "Solo puedes cambiar al estado adyacente."
      return redirect_to @objeto
    end

    if idx_destino > idx_actual
      if @objeto.puede_avanzar?
        @objeto.avanzar!
        flash[:notice] = "Etapa avanzada a #{ClssEtpTsk.etp_nombre[@objeto.etapa.to_sym]}."
      else
        flash[:alert] = "No se puede avanzar: falta información requerida."
      end
    elsif idx_destino < idx_actual
      if @objeto.puede_retroceder?(current_usuario)
        @objeto.retroceder!
        flash[:notice] = "Etapa retrocedida a #{ClssEtpTsk.etp_nombre[@objeto.etapa.to_sym]}."
      else
        flash[:alert] = "No tienes permisos para retroceder."
      end
    end

    redirect_to @objeto
  end

  # GET /krn_denuncias/new
  def new
#    @objeto = KrnDenuncia.new(ownr_type: params[:oclss], ownr_id: params[:oid], fecha_hora: Time.zone.now)
    @ownr = params[:oclss].present? && params[:oid].present? ? params[:oclss].constantize.find(params[:oid]) : nil
    @form = DenunciaForms::EtpRcpcnForm.new(ownr_type: params[:oclss], ownr_id: params[:oid], fecha_hora: Time.zone.now, etapa: 'etp_rcpcn')
    @form.denuncia.ownr = @ownr  # precargamos la empresa
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
    @form = form_class.new(form_attributes_from_denuncia)
    @form.denuncia_id = @objeto.id
  end

  # POST /krn_denuncias or /krn_denuncias.json
  def create
    @form = DenunciaForms::EtpRcpcnForm.new(krn_denuncia_params)

    respond_to do |format|
      if @form.save
        format.html { redirect_to shw_dnnc_tab_indx(@form.to_model, 1), notice: "Denuncia fue exitosamente creada." }
        format.json { render :show, status: :created, location: @form }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /krn_denuncias/1 or /krn_denuncias/1.json
  def update
    @form = form_class.new(krn_denuncia_params)
    @form.denuncia_id = @objeto.id

    Rails.logger.debug ">>> PARAMS FECHA: #{params[:krn_denuncia][:fecha].inspect}"
    Rails.logger.debug ">>> PERMITTED: #{krn_denuncia_params[:fecha].inspect}"

    respond_to do |format|
      if @form.save
        format.html { redirect_to shw_dnnc_tab_indx(@form.to_model, 0), notice: "Denuncia fue exitosamente actualizada." }
        format.json { render :show, status: :ok, location: @form }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @form.errors, status: :unprocessable_entity }
      end
    end
  end

  def anonimizar_expediente
    if params[:g].present?
      grupo = params[:g].to_sym
      @objeto.generar_expediente_anonimizado_async!(grupo)
      ntc = "Grupo #{params[:g]} anonimizado exitosamente!"
    else
      ntc = 'Error de anonimización: grupo no identificado.'
    end

    redirect_to shw_dnnc_tab_indx(@objeto, 4), notice: ntc
  end

  ### DEPRECATED
  def generar_ownr_pdf

    unless params[:code].blank?
      code = params[:code]
      generar_pdf(code,
        ownr: @objeto,
        objeto_id: @objeto.id,
        enviar_email: false
      )
    end
  end

  # GET /krn_denuncias/:id/pdf_combinado
  def pdf_combinado
    combinado = @objeto.unir_pdfs!        # genera si aún no existe

    redirect_to dnnc_path(@objeto, 3)     
  end

  def pdf_designacion
    combinado = @objeto.generar_dsgncn!        # genera si aún no existe

    redirect_to dnnc_path(@objeto, 3)     
  end

  def pdf_notificaciones
    combinado = @objeto.generar_ntfccns!        # genera si aún no existe

    redirect_to dnnc_path(@objeto, 3)     
  end

  def pdf_declaraciones
    combinado = @objeto.generar_dclrcns!        # genera si aún no existe

    redirect_to dnnc_path(@objeto, 3)     
  end

  def pdf_pruebas
    combinado = @objeto.generar_prbs!        # genera si aún no existe

    redirect_to dnnc_path(@objeto, 3)     
  end

  # DELETE /krn_denuncias/1 or /krn_denuncias/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to default_redirect_path(@objeto), notice: "Denuncia fue exitosamente eliminada." }
      format.json { head :no_content }
    end
  end

  def annmzr
    # @objeto es la denuncia (asegúrate de haberla cargado antes)
    act = @objeto.act_archivos.find_by(act_archivo: 'denuncia')

    if act
      AnonimizaPdfJob.perform_later(@objeto.id, act.pdf.blob.id)
      ntc = 'Anonimización en curso. El nuevo archivo aparecerá en segundos.'
    else
      ntc = 'Archivo fuente no encontrado'
    end

    redirect_to dnnc_path(@objeto, 0), ntc: ntc
  end

  def prg
    @objeto.rep_archivos.each do |arch|
      arch.delete
    end

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
      dnncnt.krn_declaraciones.each do |dclrcn|
        dclrcn.delete
      end
      dnncnt.krn_testigos.each do |tstg|
        tstg.rep_archivos.each do |arch|
          arch.delete
        end
        tstg.krn_declaraciones.each do |dclrcn|
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
      dnncd.krn_declaraciones.each do |dclrcn|
        dclrcn.delete
      end
      dnncd.krn_testigos.each do |tstg|
        tstg.rep_archivos.each do |arch|
          arch.delete
        end
        tstg.krn_declaraciones.each do |dclrcn|
          dclrcn.delete
        end
        tstg.delete
      end
      dnncd.delete
    end

    @objeto.krn_derivaciones.each do |drvcn|
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

    redirect_to dnnc_path(@objeto, 0)
  end

  private

    def form_class
      case @objeto.etapa
      when 'etp_rcpcn'      then DenunciaForms::EtpRcpcnForm
      when 'etp_invstgcn'   then DenunciaForms::EtpInvstgcnForm
      when 'etp_infrm'      then DenunciaForms::EtpInfrmForm
      when 'etp_prnncmnt'   then DenunciaForms::EtpPrnncmntForm
      when 'etp_mdds_sncns' then DenunciaForms::EtpMddsSncnsForm
      when 'etp_cerrada'    then DenunciaForms::EtpCerradaForm
      end
    end

    def form_attributes_from_denuncia
      # Solo los campos que el Form Object entiende
      @objeto.slice(form_class.attribute_types.keys.map(&:to_s))
    end

    def campos_permitidos
      etapa = if @objeto.present? && %w[update edit].include?(params[:action])
                @objeto.etapa
              elsif @form.present? && @form.etapa.present?
                @form.etapa
              elsif params[:action] == 'create'
                'etp_rcpcn'
              else
                params.dig(:krn_denuncia, :etapa) || 'etp_rcpcn'
              end

      case etapa
      when 'etp_rcpcn'      then KrnDenuncia::DnncEtapas::FLDS_RCPCN
      when 'etp_invstgcn'   then KrnDenuncia::DnncEtapas::FLDS_INVSTGCN
      when 'etp_infrm'      then KrnDenuncia::DnncEtapas::FLDS_INFRM
      when 'etp_prnncmnt'   then KrnDenuncia::DnncEtapas::FLDS_PRNNCMNT
      when 'etp_mdds_sncns' then KrnDenuncia::DnncEtapas::FLDS_MDDS_SNCNS
      when 'etp_cerrada'    then KrnDenuncia::DnncEtapas::FLDS_CERRADA
      else []
      end
    end

    def authorize_admin
      unless current_usuario.admin?
        flash[:alert] = "No tienes permisos para retroceder etapas."
        redirect_to @objeto
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_krn_denuncia
      @tbs = ['Proceso', 'Participantes', 'Declaraciones', 'Reportes']
      prms = params[:id].split('_')
      @indx = prms[1].blank? ? (tipo_usuario == 'recepción' ? 1 : 0) : prms[1].to_i
      @objeto = action_name == 'show' ? KrnDenuncia.estrctr.find(prms[0]) : KrnDenuncia.find(prms[0])
    end

    # Only allow a list of trusted parameters through.
    def krn_denuncia_params
      params.require(:krn_denuncia).permit(campos_permitidos)
    end
end