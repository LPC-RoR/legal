module MailDesk
  extend ActiveSupport::Concern

  def set_vrfccn_fields
    @objeto.verification_token    = SecureRandom.urlsafe_base64
    @objeto.n_vrfccn_lnks         = (@objeto.n_vrfccn_lnks || 0) + 1
    @objeto.fecha_vrfccn_lnk      = Time.zone.now
    @objeto.verification_sent_at  = Time.current
  end

  def enviar_correo_verificacion(key)
    Contexts::Investigations::VrfccnEmailMailer
      .prtcpnt_confirmation(key, @objeto.id)
      .deliver_later
  end

  def reenviar_correo
    @objeto = mdl_sym_to_mld[params[:key].to_sym].find(params[:id])
    
    set_vrfccn_fields
    
    respond_to do |format|
      if @objeto.save
        enviar_correo_verificacion(params[:key])
        
        format.html { redirect_to default_redirect_path(@objeto), notice: "Correo de verificación reenviado exitosamente." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { redirect_to default_redirect_path(@objeto), alert: "No se pudo reenviar el correo." }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  def mdl_sym_to_mld
    {
      invstgdr: KrnInvestigador,
      extrn:    KrnEmpresaExterna,
      cntct:    AppContacto,
      nmn:      AppNomina,
      dnncnt:   KrnDenunciante,
      dnncd:    KrnDenunciado,
      tstg:     KrnTestigo
    }
  end

  def dnncnt_info_oblgtr
    context     = :investigations
    objeto      = @objeto

    # Configurar URL options para ActiveStorage en el contexto actual
    set_active_storage_url_options!

    emprs_logo  = @objeto&.ownr&.logo&.url
    emprs_sign  = @objeto&.ownr&.sign&.url
    @head_url   = emprs_logo ? emprs_logo : "#{root_url}mssgs/email_head.png"
    @sign_url   = emprs_logo ? emprs_sign : "#{root_url}mssgs/email_sign.png"

    objeto.krn_denunciantes.each do |dnncnt|
      filename = "info_obligatoria_dnncnt_#{dnncnt.id}_#{Time.current.to_i}.pdf"
      @krn_kywrd = dnncnt.kywrd[:krn]
      
      html = generar_html_pdf(objeto, dnncnt, context)
      pdf_content = generar_pdf_con_grover(html, @objeto)
      
      act_archivo = crear_act_archivo(dnncnt, pdf_content, filename)
      
      optn_email = dnncnt.tiene_email_validado? || dnncnt.tiene_email_verificado?
      optn_certf = dnncnt.articulo_516?

      if (not optn_certf) and optn_email
        enviar_pdf_por_correo(objeto, dnncnt, act_archivo, context)
      end
    end

    redirect_to "/krn_denuncias/#{@objeto.id}_1", 
      notice: 'Documentos generados y archivados correctamente'
  end

  def generar_html_pdf(objeto, dnncnt, context)
    recipient = OpenStruct.new(
      email: dnncnt.email,
      nombre: dnncnt.nombre
    )

    # Configurar ActiveStorage URL options
    set_active_storage_url_options! if respond_to?(:request)
    
    # Obtener branding con manejo de errores
    branding = objeto.ownr&.tenant&.branding_for(context)
    
    # Resolver logo URL manualmente para evitar errores de ActiveStorage
    logo_url = resolve_logo_url(branding)

    html = ApplicationController.render(
      template: 'mailers/contexts/investigations/document/dnncnt_info_oblgtr_pdf',
      layout: 'mailers/pdf/base',
      assigns: {
        record: objeto,
        recipient: recipient,
        branding: branding,
        logo_url: logo_url,
        head_url: @head_url,      # ✅ AGREGAR ESTA LÍNEA
        sign_url: @sign_url,      # ✅ AGREGAR ESTA LÍNEA
        krn_kywrd: @krn_kywrd,
        info_obligatoria: nil,
        plazo_dias: 15
      }
    )

    # Forzar UTF-8 y asegurar meta charset
    html = html.force_encoding('UTF-8').encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
    
    # Asegurar que el HTML tenga el charset correcto
    unless html.include?('<meta charset="UTF-8">')
      html = html.sub(/<head>/i, '<head><meta charset="UTF-8">')
    end

    html
  end

  private

  def resolve_logo_url(branding)
    return nil unless branding&.respond_to?(:logo)
    return nil unless branding.logo&.attached?

    # Para servicio local, generar URL absoluta
    if Rails.application.config.active_storage.service == :local
      Rails.application.routes.url_helpers.url_for(branding.logo)
    else
      # Para S3 u otros servicios en la nube
      branding.logo.url
    end
  rescue => e
    Rails.logger.error "Error resolviendo logo URL: #{e.message}"
    nil
  end

  def set_active_storage_url_options!
    ActiveStorage::Current.url_options = {
      host: request.host,
      port: request.port,
      protocol: request.protocol
    }
  end

  # CORREGIDO: Grover.new solo acepta 1 argumento (hash con :html y opciones)
  def generar_pdf_con_grover(html, objeto = nil)
    empresa = objeto&.ownr
    razon_social = empresa&.razon_social || "Empresa"
    fecha = I18n.l(Time.current, format: :long)
    
    # Template de header (parte superior)
    header_template = ' '
#    header_template = <<-HTML
#      <div style="font-size: 9pt; font-family: 'Open Sans', sans-serif; 
#                  width: 100%; padding: 0 15mm; margin-top: 10mm;
#                  display: flex; justify-content: space-between; align-items: center;">
#        <span style="font-weight: 600; color: #0d6efd;">#{razon_social}</span>
#        <span style="color: #6c757d; font-size: 8pt;">Página <span class="pageNumber"></span> de <span class="totalPages"></span></span>
#      </div>
#    HTML

    # Template de footer (parte inferior)
    footer_template = <<-HTML
      <div style="font-size: 8pt; font-family: 'Open Sans', sans-serif; 
                  width: 100%; padding: 0 15mm; margin-bottom: 10mm;
                  display: flex; justify-content: space-between; align-items: center;">
        <span style="color: #adb5bd;">#{razon_social}</span>
        <span style="color: #adb5bd; font-size: 7pt;">#{fecha}</span>
      </div>
    HTML

    Grover.new(html,
      format: 'Letter',
      margin: {
        top: '25mm',      # Aumentar para dar espacio al header
        bottom: '25mm',   # Aumentar para dar espacio al footer
        left: '15mm',
        right: '15mm'
      },
      print_background: true,
      prefer_css_page_size: false,
      emulate_media: 'print',
      wait_until: 'networkidle0',
      display_url: Rails.application.routes.url_helpers.root_url(
        host: request.host_with_port,
        protocol: request.protocol
      ),
      # Templates personalizados
      header_template: header_template,
      footer_template: footer_template,
      # Ocultar header/footer por defecto de Chrome
      launch_args: ['--no-sandbox', '--disable-setuid-sandbox']
    ).to_pdf
  end

  def crear_act_archivo(dnncnt, pdf_content, filename)
    Rails.logger.info "=== CREAR_ACT_ARCHIVO ==="
    Rails.logger.info "pdf_content: #{pdf_content.class}, #{pdf_content.length} bytes, PDF? #{pdf_content.start_with?('%PDF')}"

    ActArchivo.transaction do
      act_archivo = ActArchivo.new(
        ownr: dnncnt,
        act_archivo: 'dnncnt_info_oblgtr',
        nombre: "Información Obligatoria - Denuncia #{dnncnt.krn_denuncia&.id}",
        tipo: 'pdf',
      )

      # Adjuntar desde StringIO
      act_archivo.pdf.attach(
        io: StringIO.new(pdf_content),
        filename: filename,
        content_type: 'application/pdf'
      )

      act_archivo.save!
      
      Rails.logger.info "ActArchivo guardado: ID #{act_archivo.id}, PDF adjunto: #{act_archivo.pdf.attached?}, tamaño: #{act_archivo.pdf.byte_size}"
      
      # NO verificar con download aquí - puede fallar por timing
      act_archivo
    end
  rescue => e
    Rails.logger.error "Error en crear_act_archivo: #{e.message}"
    Rails.logger.error e.backtrace.first(5).join("\n")
    raise
  end

  def enviar_pdf_por_correo(objeto, dnncnt, act_archivo, context)
    recipient = OpenStruct.new(
      email: dnncnt.email,
      nombre: dnncnt.nombre
    )

    # DESCARGAR el PDF desde ActiveStorage
    pdf_data = act_archivo.pdf.download

    options = {
      mailer_action: :dnncnt_info_oblgtr,
      subject: "Información obligatoria para personas denunciantes - Denuncia N° #{objeto.id}",
      act_archivo: act_archivo,
      pdf_data: pdf_data,  # ← Pasar el PDF ya descargado
      filename: "información_obligatoria_denunciante - #{dnncnt.kywrd[:krn]}"
#      filename: act_archivo.pdf.filename.to_s
    }

    Mailers::PdfDeliveryService.new(
      context,
      :document,
      objeto,
      recipient,
      options
    ).deliver_now
  end
  
end