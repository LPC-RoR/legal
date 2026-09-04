class Repositorios::ActArchivosController < ApplicationController
  include PdfGeneratable

  before_action :set_act_archivo, only: %i[ show_pdf edit update destroy download annmzr excluir resumir anonimizar enviar_pdf_por_email]
  before_action :authenticate_usuario!
  before_action :scrty_on

  include ActCheck

  # GET /act_archivos or /act_archivos.json
  def index
    @coleccion = ActArchivo.all
  end

  # GET /act_archivos/1 or /act_archivos/1.json
  def show_pdf
    archivo = ActArchivo.find(params[:id])
    
    content = archivo.pdf.download
    
    # Si no es PDF, guardar para inspeccionar
    unless content.start_with?('%PDF')
      File.write(Rails.root.join('tmp', "error_show_pdf_#{archivo.id}.txt"), content)
      Rails.logger.error "ERROR: Contenido no es PDF, guardado en tmp/error_show_pdf_#{archivo.id}.txt"
    end
    
    send_data content,
              filename: archivo.pdf.filename.to_s,
              type: 'application/pdf',
              disposition: 'inline'
  end

  def download
    doc = ActArchivo.find(params[:id])
    authorize doc

    unless doc.pdf.attached?
      redirect_back fallback_location: root_path, alert: 'Archivo no disponible'
      return                # <── important
    end

    redirect_to rails_blob_url(doc.pdf, disposition: 'attachment')
  end

  # GET /act_archivos/new
  def new
    mdl   = ClssPdf.context_class(params[:code])
    code  = params[:code]
    @objeto = ActArchivo.new(ownr_type: params[:oclss], ownr_id: params[:oid], act_archivo: code, mdl: mdl, crtn_mode: 'upload')
  end

  # GET /act_archivos/1/edit
  def edit
  end

  # POST /act_archivos or /act_archivos.json
  def create
    @objeto = ActArchivo.new(act_archivo_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to act_archivo_rdrccn(@objeto), notice: "Archivo fue exitosamente creado." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /act_archivos/1 or /act_archivos/1.json
  def update
    respond_to do |format|
      if @objeto.update(act_archivo_params)
        format.html { redirect_to act_archivo_rdrccn(@objeto), notice: "Archivo fue exitosamente actualizado." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # ============================================
  # GENERAR PDF USANDO FORMATO
  # ============================================
  # @param codigo_pdf [String] Código del reporte a generar
  # @param did [integer] id de la dnnc
  def generar_pdf
    codigo_pdf = params[:codigo_pdf]

    cntxt_clss = ClssPdf.context_for(codigo_pdf)
    
    # Verificaciones de codigo_pdf y valid_report?: REVISAR funcionamiento
    unless codigo_pdf.present?
      return render json: { error: "Se requiere parámetro codigo_pdf" }, status: :bad_request
    end

    unless ClssPdf.valid_report?(codigo_pdf)
      return render json: { error: "Reporte no válido: #{codigo_pdf}" }, status: :bad_request
    end

    # Obtener la denuncia asociada
    krn_denuncia = KrnDenuncia.find(params[:did])
    
    # Determinar participantes según el tipo de reporte
    participantes = obtener_participantes(krn_denuncia, codigo_pdf)
    
    if participantes.empty?
      return render json: { error: "No hay participantes para generar el PDF" }, status: :unprocessable_content
    end

    # Generar PDFs múltiples (uno por participante)
    generar_pdf_multiples(codigo_pdf, 
      objeto_id: @objeto.id,
      participantes: participantes,
      async: false
    )
  end

  # app/controllers/repositorios/act_archivos_controller.rb
  def annmzr
    @archivo = ActArchivo.find(params[:id])
    
    # 🚨 REGENERAR METADATA ANTES DE ANONIMIZAR
    @archivo.generar_metadata_anonimizacion
    
    resultado = @archivo.generar_pdf_anonimizado!
    
    if resultado
      redirect_to "/krn_denuncias/#{@objeto.ownr.dnnc.id}_#{@objeto.act_archivo == 'declaracion' ? 1 : 0}", 
        notice: "Documento anonimizado correctamente"
    else
      redirect_to "/krn_denuncias/#{@objeto.ownr.dnnc.id}_#{@objeto.act_archivo == 'declaracion' ? 1 : 0}", 
        alert: "No se pudo anonimizar. Verifica que la denuncia tenga datos reales."
    end
  end

  def resumir
    dnnc = @objeto.ownr.dnnc
    nombres = dnnc.hash_nombres_anonimizacion

    GenerarResumenJob.perform_later(@objeto.id, nombres)

    redirect_to act_archivo_rdrccn(@objeto), notice: "El resumen cronológico se está generando."
  end

  def anonimizar
    dnnc = @objeto.ownr.dnnc
    nombres = dnnc.hash_nombres_anonimizacion

    AnonimizarTextoJob.perform_later(@objeto.id, nombres)

    redirect_to act_archivo_rdrccn(@objeto), notice: "El texto anonimizado se está generando."
  end

  # CONTEXT MAIL
  # ============================================
  # ENVIAR PDF POR EMAIL — DOCUMENTACIÓN LEGAL
  # ============================================
  def enviar_pdf_por_email
    unless @objeto.pdf.attached?
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: "El PDF no está disponible. Genérelo primero." }
        format.json { render json: { error: "PDF no adjunto" }, status: :not_found }
      end
      return
    end

    cntxt_clss = ClssPdf.context_class(@objeto.act_archivo)
    asunto     = "Ley 21.643 - #{cntxt_clss.nombre[@objeto.act_archivo]}"

    # Si necesitas datos_layout específicos, constrúyelos aquí y pásalos.
    # Si no, el modelo usa reconstruir_datos_layout_por_defecto.
    datos_layout = nil  # o construir_datos_layout_desde_controller(@objeto)

    exito = @objeto.enviar_pdf_por_email(
      destinatario: @objeto.ownr&.email,
      asunto:       asunto,
      datos_layout: datos_layout
    )

    if exito
      @objeto.update(sndd: true)
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: "Documento enviado correctamente." }
        format.json { render json: { exito: true, mensaje: "Email enviado", email_legal_id: @objeto.email_legals.enviado.last&.id } }
      end
    else
      # El email_legal ya fue creado con estado :fallido y el error guardado
      ultimo_error = @objeto.email_legales.fallidos.last&.error || "Error desconocido"
      
      respond_to do |format|
        format.html { 
          redirect_back fallback_location: root_path, 
          alert: "ERROR: El email NO fue enviado. Motivo: #{ultimo_error}. Reintente manualmente." 
        }
        format.json { 
          render json: { 
            exito: false, 
            error: "Email no enviado",
            detalle: ultimo_error,
            advertencia: "Documento legal NO notificado. Reintente manualmente inmediatamente."
          }, status: :unprocessable_content 
        }
      end
    end
  end

  # DELETE /act_archivos/1 or /act_archivos/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to act_archivo_rdrccn(@objeto), status: :see_other, notice: "Archivo fue exitosamente eliminado." }
      format.json { head :no_content }
    end
  end

  # Para descargar los archivos generados por OpenAI
  def descargar_archivo_generado
    @act_archivo = ActArchivo.find(params[:id])
    tipo = params[:tipo]
    
    archivo = case tipo
    when 'participantes'
      @act_archivo.lista_participantes
    when 'resumen'
      @act_archivo.resumen_anonimizado
    when 'hechos'
      @act_archivo.lista_hechos
    end

    if archivo.attached?
      redirect_to rails_blob_url(archivo, disposition: "attachment")
    else
      redirect_to @act_archivo, alert: "El archivo no está disponible"
    end
  end

  private
    # ============================================
    # DETERMINAR PARTICIPANTES SEGÚN REPORTE
    # ============================================
    def obtener_participantes(krn_denuncia, codigo_pdf)
      case codigo_pdf
      when 'crdncn_apt'
        # Todos los denunciantes y denunciados
        krn_denuncia.ownr.app_contactos.where(grupo: 'Apt')
      when 'infrmcn'
        krn_denuncia.ownr.app_contactos.where(grupo: 'RRHH')
      else
        krn_denuncia.krn_denunciantes + krn_denuncia.krn_denunciados
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_act_archivo
      @objeto = ActArchivo.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def act_archivo_params
      params.expect(act_archivo: [ :ownr_type, :ownr_id, :act_archivo, :mdl, :control_fecha, :nombre, :fecha, :pdf, 
        :crtn_mode, :no_annm ])
    end
end
